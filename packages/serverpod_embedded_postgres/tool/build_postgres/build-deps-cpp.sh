#!/usr/bin/env bash
# Build the C++ dependencies of PostGIS as static libs into $DEPS, using zig c++.
# (GEOS - geometry engine; PROJ - projections, needs sqlite3 from build-deps-c.sh)
set -euo pipefail
B="${PGBUILD:-$HOME/pgzig}"; DEPS="$B/deps"; SRC="$B/src"; LOG="$B/logs"; mkdir -p "$LOG"
WCC="$B/zigshim/zig-cc"; WCXX="$B/zigshim/zig-cxx"
export PATH="$DEPS/bin:$PATH"
J="$(getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)"

echo "=== GEOS 3.13.0 ($(date +%H:%M:%S)) ==="
cd "$SRC/geos-3.13.0"
rm -rf build && mkdir build && cd build
cmake -G "Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX="$DEPS" \
  -DCMAKE_C_COMPILER="$WCC" -DCMAKE_CXX_COMPILER="$WCXX" \
  -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=OFF -DBUILD_DOCUMENTATION=OFF \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 .. >"$LOG/dep-geos.log" 2>&1
make -j"$J" >>"$LOG/dep-geos.log" 2>&1
make install >>"$LOG/dep-geos.log" 2>&1
echo "geos: $("$DEPS/bin/geos-config" --version 2>/dev/null)"

echo "=== PROJ 9.5.1 ($(date +%H:%M:%S)) ==="
cd "$SRC/proj-9.5.1"
rm -rf build && mkdir build && cd build
cmake -G "Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX="$DEPS" \
  -DCMAKE_C_COMPILER="$WCC" -DCMAKE_CXX_COMPILER="$WCXX" \
  -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=OFF -DBUILD_APPS=OFF \
  -DENABLE_CURL=OFF -DENABLE_TIFF=OFF -DBUILD_PROJSYNC=OFF \
  -DEXE_SQLITE3="$DEPS/bin/sqlite3" \
  -DSQLITE3_INCLUDE_DIR="$DEPS/include" -DSQLITE3_LIBRARY="$DEPS/lib/libsqlite3.a" \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 .. >"$LOG/dep-proj.log" 2>&1
make -j"$J" >>"$LOG/dep-proj.log" 2>&1
make install >>"$LOG/dep-proj.log" 2>&1
echo "proj: $("$DEPS/bin/proj" 2>&1 | head -1 || true); lib $(ls "$DEPS"/lib/libproj.* >/dev/null 2>&1 && echo OK || echo MISSING)"

echo "=== ALL C++ DEPS DONE ($(date +%H:%M:%S)) ==="
ls "$DEPS/lib"/libgeos* "$DEPS/lib"/libproj* 2>/dev/null | sed 's#.*/##'
