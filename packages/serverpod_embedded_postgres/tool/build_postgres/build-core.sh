#!/usr/bin/env bash
# Build postgres 16.13 core with zig as the C/C++ compiler (macOS host).
# Produces an install whose pg_config reports the zig wrapper as CC/CXX, so
# downstream PGXS/PostGIS builds inherit it, and whose backend exports all its
# globals (force-keep) so dlopen'd extensions resolve them at runtime.
set -euo pipefail

B="${PGBUILD:-$HOME/pgzig}"; SRC="$B/src/postgresql-16.13"; PREFIX="$B/out/pg"; LOG="$B/logs"; mkdir -p "$LOG"
WCC="$B/zigshim/zig-cc"; WCXX="$B/zigshim/zig-cxx"
J="$(getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)"
export CC="$WCC" CXX="$WCXX"

cd "$SRC"
make distclean >/dev/null 2>&1 || true
rm -rf "$PREFIX"

# Patch the backend link recipe to accept a $(PG_EXPORTS) slot (default empty),
# which we fill below with the force-keep response file. Idempotent.
grep -q 'PG_EXPORTS' src/backend/Makefile || \
  sed -i.bak 's#$(LDFLAGS) $(LIBS) -o $@#$(LDFLAGS) $(PG_EXPORTS) $(LIBS) -o $@#' src/backend/Makefile
grep -q 'PG_EXPORTS' src/backend/Makefile || {
  echo "ERROR: failed to patch src/backend/Makefile with \$(PG_EXPORTS)" >&2; exit 1; }

echo "=== configure ($(date +%H:%M:%S)) ==="
# Surface config.log on failure - configure only prints "cannot proceed" to
# stdout; the actual compiler/linker error (conftest) lives in config.log, and
# the scratch tree is gone by the time CI logs are inspected.
./configure --prefix="$PREFIX" \
  --without-icu --without-readline --without-zlib \
  --without-zstd --without-lz4 --without-gssapi --without-ldap --without-openssl \
  || {
    echo "=== configure FAILED - config.log diagnostics ==="
    echo "--- resolved flags ---"
    grep -E '^(CC|CFLAGS|CXXFLAGS|CPPFLAGS|LDFLAGS|LIBS|template)=' config.log || true
    echo "--- failing 'still works' conftest (command + error) ---"
    sed -n '/whether the C compiler still works/,/result: no/p' config.log || true
    echo "--- compiler/linker error lines anywhere in config.log ---"
    grep -nE ': error:|: fatal error:|undefined (reference|symbol)|ld\.lld|cannot find|unrecognized|unsupported|conftest.*\$\? = [1-9]' config.log | tail -40 || true
    echo "--- last 60 lines of config.log ---"
    tail -n 60 config.log
    exit 1
  }

echo "=== make ($(date +%H:%M:%S)) ==="
make -j"$J"

# --- Force-keep every backend global so extensions resolve them at runtime ---
# zig 0.16's mach-o linker GCs globals unreferenced in the link graph and
# ignores -rdynamic / -exported_symbols_list for them. The postgres extension
# API (e.g. RelnameGetRelid) is referenced only by external dlopen'd modules,
# so we force each backend global undefined (-Wl,-u,<sym>) which makes the
# linker keep it; -rdynamic then exports them (like Linux --export-dynamic).
echo "=== generate force-keep export list ($(date +%H:%M:%S)) ==="
cd "$SRC/src/backend"
rm -f postgres
# make -n emits object paths with mixed roots; normalize to src/backend-relative
# (strip a stray src/backend/ prefix) and keep only ones that exist.
make -n postgres 2>/dev/null | tr ' ' '\n' | grep -E '\.(o|a)$' | sed 's#^src/backend/##' | sort -u > "$B/objlist.raw"
: > "$B/objlist.txt"; while read -r f; do [ -f "$f" ] && echo "$f" >> "$B/objlist.txt"; done < "$B/objlist.raw"
nm -g $(cat "$B/objlist.txt") 2>/dev/null | awk '$2 ~ /^[TDBSIC]$/ {print $3}' | sort -u > "$B/exports.txt"
awk '{print "-Wl,-u," $0}' "$B/exports.txt" > "$B/uflags.rsp"
echo "force-keeping $(wc -l < "$B/exports.txt") backend symbols"

echo "=== relink + install ($(date +%H:%M:%S)) ==="
cd "$SRC"
make -j"$J" PG_EXPORTS="@$B/uflags.rsp -rdynamic"
make install PG_EXPORTS="@$B/uflags.rsp -rdynamic"

echo "=== verify ($(date +%H:%M:%S)) ==="
echo "pg_config --cc: $("$PREFIX/bin/pg_config" --cc)"
# Confirm a backend-only symbol is actually exported for dlopen'd extensions.
# Toolchain differs per OS: dyld_info (mach-o) vs nm -D (ELF dynsym); on
# Windows the PE export check is unreliable, so skip it there.
case "$(uname -s)" in
  Darwin) echo "RelnameGetRelid exported: $(xcrun dyld_info -exports "$PREFIX/bin/postgres" 2>/dev/null | grep -c RelnameGetRelid)" ;;
  Linux)  echo "RelnameGetRelid exported: $(nm -D "$PREFIX/bin/postgres" 2>/dev/null | grep -c RelnameGetRelid)" ;;
  *)      echo "RelnameGetRelid export check skipped on $(uname -s)" ;;
esac
echo "=== ALL DONE ($(date +%H:%M:%S)) ==="
