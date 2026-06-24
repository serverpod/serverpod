#!/usr/bin/env bash
# Assemble a relocatable bundle: postgres install tree + the shared geo deps +
# PROJ data, named serverpod-postgres-<bom>-<os>-<arch>.tar.xz (+ .sha256).
#
# Per-OS layout: macOS rewrites install_names/rpaths (verified); Windows drops
# the geo DLLs beside postgres.exe (no rpath); Linux ($ORIGIN rpath) is TODO.
# Windows + Linux are UNVALIDATED - pending CI.
set -euo pipefail
B="${PGBUILD:-$HOME/pgzig}"; PREFIX="$B/out/pg"; DEPS="$B/deps"; OUT="$B/dist"
VER="${PG_VERSION:-16.13.0}"
OS="${BUNDLE_OS:-$(uname -s | tr '[:upper:]' '[:lower:]' | sed -E 's/darwin/macos/; s/(mingw|msys|cygwin).*/windows/')}"
ARCH="${BUNDLE_ARCH:-$(uname -m | sed 's/x86_64/x64/; s/aarch64/arm64/')}"
NAME="serverpod-postgres-${VER}-${OS}-${ARCH}"
STAGE="$OUT/$NAME"

rm -rf "$STAGE"; mkdir -p "$STAGE"
# postgres install tree (prune headers/static libs not needed at runtime)
cp -R "$PREFIX/." "$STAGE/"
rm -rf "$STAGE/include" "$STAGE/lib/pkgconfig" "$STAGE"/lib/*.a 2>/dev/null || true

# PROJ runtime data (proj.db etc.) - OS-agnostic. The launcher sets PROJ_LIB
# to <install>/share/proj (see supervisor.dart).
mkdir -p "$STAGE/share/proj"; cp -R "$DEPS"/share/proj/. "$STAGE/share/proj/"

case "$(uname -s)" in
Darwin)
  # Shared geo deps live in lib/ next to postgres's own dylibs.
  cp -P "$DEPS"/lib/libgeos_c.* "$DEPS"/lib/libgeos.* "$DEPS"/lib/libproj.* "$STAGE/lib/" 2>/dev/null || true
  # postgres bakes absolute install_names + build-tree rpaths; rewrite every
  # Mach-O's build-prefix refs to @rpath/<leaf> and add the @loader_path rpath
  # that resolves to the bundle's lib/. Relies on the
  # -headerpad_max_install_names that _zigwrap adds on Darwin link steps.
  relocate() {  # $1=file  $2=rpath-to-lib
    local f="$1" rp="$2" dep
    case "$f" in *.dylib) install_name_tool -id "@rpath/$(basename "$f")" "$f" 2>/dev/null || true ;; esac
    otool -L "$f" | awk 'NR>1{print $1}' | while read -r dep; do
      case "$dep" in
        "$PREFIX"/*|"$DEPS"/*) install_name_tool -change "$dep" "@rpath/$(basename "$dep")" "$f" 2>/dev/null || true ;;
      esac
    done
    install_name_tool -add_rpath "$rp" "$f" 2>/dev/null || true
    # arm64 requires a (re)signature after install_name_tool; on x64 it is
    # unnecessary (ad-hoc signing these zig-built dylibs tripped loader crashes
    # on macOS 26).
    [ "$(uname -m)" = arm64 ] && codesign -f -s - "$f" 2>/dev/null || true
  }
  for f in "$STAGE"/bin/*;                  do [ -L "$f" ] || { file "$f" | grep -q Mach-O && relocate "$f" "@loader_path/../lib"; }; done
  for f in "$STAGE"/lib/*.dylib;            do [ -L "$f" ] || relocate "$f" "@loader_path"; done
  for f in "$STAGE"/lib/postgresql/*.dylib; do [ -L "$f" ] || relocate "$f" "@loader_path/.."; done
  ;;
MINGW*|MSYS*|CYGWIN*)
  # Windows (UNVALIDATED - pending CI): shared libs are .dll, installed by
  # CMake into bin/. postgres.exe's dir (bin/) is on the default DLL search
  # path, so the geo DLLs that postgis-3.dll depends on resolve there - no
  # rpath/install_name surgery. NOTE: if postgres's own DLLs (libpq etc.) land
  # in lib/ rather than bin/, they may need moving to bin/ too.
  cp "$DEPS"/bin/libgeos_c*.dll "$DEPS"/bin/libgeos*.dll "$DEPS"/bin/libproj*.dll "$STAGE/bin/" 2>/dev/null || true
  ;;
*)
  # Linux (UNVALIDATED - pending CI): .so in lib/; ELF $ORIGIN-rpath relocation
  # is still TODO (postgis-3.so must find lib/ via -Wl,-rpath,'$ORIGIN/..').
  cp -P "$DEPS"/lib/libgeos_c.so* "$DEPS"/lib/libgeos.so* "$DEPS"/lib/libproj.so* "$STAGE/lib/" 2>/dev/null || true
  echo "WARNING: Linux \$ORIGIN-rpath relocation not implemented yet; bundle may not be portable." >&2
  ;;
esac

cd "$OUT"
# Archive STAGE's *contents* (bin/ lib/ share/ at the tar root), NOT a wrapper
# directory: BinaryStore extracts verbatim into installDir and expects
# installDir/bin/postgres, with no leading-component strip.
#
# Force plain ustar and strip macOS metadata. package:archive (BinaryStore's
# Dart extractor) can't decode PAX extended headers - it UTF-8-decodes header
# fields and throws ("Unexpected extension byte") on the raw bytes macOS bsdtar
# emits to carry xattrs such as com.apple.provenance. ustar suffices: every path
# and symlink target is well under its 100-byte limit. Applied unconditionally,
# since the failure depends on host xattrs.
tar_opts="--format=ustar"
case "$(uname -s)" in
  Darwin) export COPYFILE_DISABLE=1; tar_opts="$tar_opts --no-mac-metadata" ;;
esac
# shellcheck disable=SC2086 # intentional word-splitting of tar_opts
tar $tar_opts -C "$STAGE" -cJf "$NAME.tar.xz" .
( command -v shasum >/dev/null && shasum -a 256 "$NAME.tar.xz" || sha256sum "$NAME.tar.xz" ) | awk '{print $1}' > "$NAME.tar.xz.sha256"
echo "bundle: $NAME.tar.xz  $(du -h "$NAME.tar.xz" | awk '{print $1}')"
echo "sha256: $(cat "$NAME.tar.xz.sha256")"
