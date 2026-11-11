#!/usr/bin/env bash
# Build the C dependencies of PostgreSQL/contrib and PostGIS into $DEPS.
# OpenSSL is shared; the remaining libraries are static and position independent.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=versions.env
. "$HERE/versions.env"
B="${PGBUILD:-$HOME/pgzig}"; DEPS="$B/deps"; SRC="$B/src"; LOG="$B/logs"; mkdir -p "$LOG"
WCC="$B/shim/cc"
export PATH="$DEPS/bin:$PATH"
J="$(getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)"

# json-c builds with cmake, which can't identify the zig wrapper on Windows and
# then names the lib MSVC-style (json-c.lib, not libjson-c.a). The wrapper is a
# pass-through to gcc there, so let cmake use native gcc; zig wrapper elsewhere.
# (sqlite/libxml2 use autoconf, which needs no compiler-ID table, so they're ok.)
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) CMAKE_CC=gcc ;;
  *)                    CMAKE_CC="$WCC" ;;
esac

echo "=== zlib ($(date +%H:%M:%S)) ==="
cd "$SRC/zlib-$ZLIB_VERSION"
cmake -S . -B build -G "Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX="$DEPS" -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_C_COMPILER="$CMAKE_CC" -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DZLIB_BUILD_SHARED=OFF -DZLIB_BUILD_STATIC=ON -DZLIB_BUILD_TESTING=OFF \
  >"$LOG/dep-zlib.log" 2>&1
cmake --build build -j"$J" >>"$LOG/dep-zlib.log" 2>&1
cmake --install build >>"$LOG/dep-zlib.log" 2>&1
# Upstream names its Windows static library libzs.a; PostgreSQL uses -lz.
if [ -f "$DEPS/lib/libzs.a" ]; then
  cp "$DEPS/lib/libzs.a" "$DEPS/lib/libz.a"
fi

echo "=== OpenSSL ($(date +%H:%M:%S)) ==="
cd "$SRC/openssl-$OPENSSL_VERSION"
case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) OPENSSL_TARGET=linux-x86_64 ;;
  Linux-aarch64) OPENSSL_TARGET=linux-aarch64 ;;
  Darwin-x86_64) OPENSSL_TARGET=darwin64-x86_64-cc ;;
  Darwin-arm64) OPENSSL_TARGET=darwin64-arm64-cc ;;
  MINGW*|MSYS*|CYGWIN*) OPENSSL_TARGET=mingw64 ;;
  *) echo "Unsupported OpenSSL target" >&2; exit 1 ;;
esac
# Keep providers built into libcrypto so relocation does not depend on a
# build-machine OPENSSLDIR or a separately located provider module.
CC="$WCC" perl ./Configure "$OPENSSL_TARGET" --prefix="$DEPS" --libdir=lib \
  shared no-module no-tests >"$LOG/dep-openssl.log" 2>&1
make -j"$J" >>"$LOG/dep-openssl.log" 2>&1
make install_sw >>"$LOG/dep-openssl.log" 2>&1

echo "=== OSSP UUID ($(date +%H:%M:%S)) ==="
cd "$SRC/uuid-$OSSP_UUID_VERSION"
# OSSP predates ARM64. Use the platform detection scripts from the pinned
# PostgreSQL source so its configure recognizes every bundle target.
cp "$SRC/postgresql-$PG_UPSTREAM_VERSION/config/config.guess" .
cp "$SRC/postgresql-$PG_UPSTREAM_VERSION/config/config.sub" .
CC="$WCC" CFLAGS="-O2 -fPIC" ./configure --prefix="$DEPS" \
  --disable-shared --enable-static --without-cxx --without-perl \
  --without-php --without-pgsql >"$LOG/dep-uuid.log" 2>&1
make -j"$J" >>"$LOG/dep-uuid.log" 2>&1
make install >>"$LOG/dep-uuid.log" 2>&1

echo "=== sqlite ($(date +%H:%M:%S)) ==="
cd "$SRC/sqlite-autoconf-$SQLITE_AUTOCONF"
make distclean >/dev/null 2>&1 || true
CC="$WCC" ./configure --prefix="$DEPS" --disable-shared --enable-static >"$LOG/dep-sqlite.log" 2>&1
make -j"$J" >>"$LOG/dep-sqlite.log" 2>&1
make install >>"$LOG/dep-sqlite.log" 2>&1
echo "sqlite: $("$DEPS/bin/sqlite3" --version | awk '{print $1}')"

echo "=== libxml2 ($(date +%H:%M:%S)) ==="
cd "$SRC/libxml2-$LIBXML2_VERSION"
make distclean >/dev/null 2>&1 || true
CC="$WCC" CFLAGS="-O2 -fPIC" ./configure --prefix="$DEPS" --disable-shared --enable-static \
  --without-python --without-lzma --without-zlib --without-iconv >"$LOG/dep-libxml2.log" 2>&1
make -j"$J" >>"$LOG/dep-libxml2.log" 2>&1
make install >>"$LOG/dep-libxml2.log" 2>&1
echo "libxml2: $("$DEPS/bin/xml2-config" --version)"

echo "=== libxslt ($(date +%H:%M:%S)) ==="
cd "$SRC/libxslt-$LIBXSLT_VERSION"
CC="$WCC" CFLAGS="-O2 -fPIC" CPPFLAGS="-DLIBXML_STATIC" \
  PKG_CONFIG_PATH="$DEPS/lib/pkgconfig" ./configure --prefix="$DEPS" \
  --disable-shared --enable-static --without-python --without-crypto \
  --with-libxml-prefix="$DEPS" >"$LOG/dep-libxslt.log" 2>&1
make -j"$J" >>"$LOG/dep-libxslt.log" 2>&1
make install >>"$LOG/dep-libxslt.log" 2>&1

echo "=== json-c ($(date +%H:%M:%S)) ==="
cd "$SRC/json-c-$JSONC_VERSION"
rm -rf build && mkdir build && cd build
cmake -G "Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX="$DEPS" \
  -DCMAKE_C_COMPILER="$CMAKE_CC" \
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
