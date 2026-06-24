#!/usr/bin/env bash
# Build the C dependencies of PostGIS as static libs into $DEPS, using zig cc.
# (sqlite3 - needed by PROJ; libxml2 - GML/KML; json-c - GeoJSON)
set -euo pipefail
B="${PGBUILD:-$HOME/pgzig}"; DEPS="$B/deps"; SRC="$B/src"; LOG="$B/logs"; mkdir -p "$LOG"
WCC="$B/zigshim/zig-cc"
export PATH="$DEPS/bin:$PATH"
J="$(getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)"

echo "=== sqlite ($(date +%H:%M:%S)) ==="
cd "$SRC/sqlite-autoconf-3470200"
make distclean >/dev/null 2>&1 || true
CC="$WCC" ./configure --prefix="$DEPS" --disable-shared --enable-static >"$LOG/dep-sqlite.log" 2>&1
make -j"$J" >>"$LOG/dep-sqlite.log" 2>&1
make install >>"$LOG/dep-sqlite.log" 2>&1
echo "sqlite: $("$DEPS/bin/sqlite3" --version | awk '{print $1}')"

echo "=== libxml2 ($(date +%H:%M:%S)) ==="
cd "$SRC/libxml2-2.13.8"
make distclean >/dev/null 2>&1 || true
CC="$WCC" ./configure --prefix="$DEPS" --disable-shared --enable-static \
  --without-python --without-lzma --without-zlib --without-iconv >"$LOG/dep-libxml2.log" 2>&1
make -j"$J" >>"$LOG/dep-libxml2.log" 2>&1
make install >>"$LOG/dep-libxml2.log" 2>&1
echo "libxml2: $("$DEPS/bin/xml2-config" --version)"

echo "=== json-c ($(date +%H:%M:%S)) ==="
cd "$SRC/json-c-0.18"
rm -rf build && mkdir build && cd build
cmake -G "Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX="$DEPS" \
  -DCMAKE_C_COMPILER="$WCC" \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_TESTING=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 >"$LOG/dep-jsonc.log" 2>&1 ..
make -j"$J" >>"$LOG/dep-jsonc.log" 2>&1
make install >>"$LOG/dep-jsonc.log" 2>&1
echo "json-c: $([ -f "$DEPS/lib/libjson-c.a" ] && echo libjson-c.a OK || echo MISSING)"

echo "=== ALL C DEPS DONE ($(date +%H:%M:%S)) ==="
ls "$DEPS/lib"/*.a 2>/dev/null | sed 's#.*/##'
