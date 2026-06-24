#!/usr/bin/env bash
# End-to-end: fetch sources, build PostgreSQL + pgvector + PostGIS with Zig,
# and package a relocatable bundle. Run on the *target* OS/arch (native
# per-runner); cross-compiling Postgres+PostGIS is not the model here.
#
#   PGBUILD=/path/to/scratch ./build-all.sh
#
# Requires on PATH: zig (0.16.x), cmake, pkg-config, bison, flex, make, curl,
# perl, tar/xz. macOS additionally uses xcrun/install_name_tool/codesign.
# Local builds: with anyzig (github.com/marler8997/anyzig), `export
# ZIG_VERSION=0.16.0` to pin the validated version; leave unset for plain zig.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
B="${PGBUILD:-$HOME/pgzig}"
WCC="$B/shim/cc"
PREFIX="$B/out/pg"
J="$(getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)"
export MAKEFLAGS="-j$J"
# Pin the macOS floor to Flutter's dev minimum (macOS 12 Monterey) so the bundle
# runs on any Serverpod-capable Mac, decoupled from the build runner's SDK -
# otherwise the runner's macOS version silently becomes the bundle's min-OS.
# Respected by clang/ld/configure/cmake; override via the env var.
case "$(uname -s)" in
  Darwin) export MACOSX_DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET:-12.0}" ;;
esac

mkdir -p "$B"
cp -R "$HERE/shim" "$B/"            # the cc/c++ wrapper the scripts expect at $B/shim
chmod +x "$B"/shim/*

echo "### fetch-sources";  "$HERE/fetch-sources.sh"
echo "### build-core";     "$HERE/build-core.sh"
echo "### build-deps-c";   "$HERE/build-deps-c.sh"
echo "### build-deps-cpp"; "$HERE/build-deps-cpp.sh"

echo "### pgvector"
cd "$B/src/pgvector-0.8.3"; make clean >/dev/null 2>&1 || true
# Portable, dispatch-free build (COPT=-DDISABLE_DISPATCH, OPTFLAGS="" => no
# -march=native). pgvector's runtime SIMD dispatch otherwise (a) emits a non-GOT
# __cpu_model relocation that lld rejects in our PIC build on Linux/glibc
# (target_clones path), and (b) compiles AVX-512 paths needing x86-only flags
# (-mevex512) that break on arm64. Disabling it builds one baseline that runs on
# any CPU (still auto-vectorized via pgvector's -ftree-vectorize) - the right
# tradeoff for a redistributable bundle.
make CC="$WCC" PG_CONFIG="$PREFIX/bin/pg_config" OPTFLAGS="" COPT="-DDISABLE_DISPATCH"
make install CC="$WCC" PG_CONFIG="$PREFIX/bin/pg_config" OPTFLAGS="" COPT="-DDISABLE_DISPATCH"

echo "### build-postgis"; "$HERE/build-postgis.sh"
echo "### package";       "$HERE/package.sh"
echo "### build-all DONE"
