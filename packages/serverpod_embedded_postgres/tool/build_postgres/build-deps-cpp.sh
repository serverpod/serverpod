#!/usr/bin/env bash
# Build the C++ dependencies of PostGIS as static libs into $DEPS, using zig c++.
# (GEOS - geometry engine; PROJ - projections, needs sqlite3 from build-deps-c.sh)
set -euo pipefail
B="${PGBUILD:-$HOME/pgzig}"; DEPS="$B/deps"; SRC="$B/src"; LOG="$B/logs"; mkdir -p "$LOG"
WCC="$B/shim/cc"; WCXX="$B/shim/cxx"
export PATH="$DEPS/bin:$PATH"
J="$(getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)"

# cmake can't identify the zig wrapper as a known compiler on Windows (it's a
# bash script that execs mingw gcc), so it gives an empty compiler ID: GEOS's
# `cxx_std_14` requirement then fails ("No known features for CXX compiler"),
# and cmake falls back to MSVC-style lib naming (json-c.lib, not libjson-c.a).
# On Windows the wrapper is a pure pass-through to gcc/g++, so point cmake
# straight at them; everywhere else cmake needs the zig wrapper.
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) CMAKE_CC=gcc;    CMAKE_CXX=g++ ;;
  *)                    CMAKE_CC="$WCC"; CMAKE_CXX="$WCXX" ;;
esac

# Windows DLL adjustments (all no-ops off Windows):
#  (1) geos_c.dll references internal libgeos C++ symbols, but GEOS's GEOS_DLL
#      macros export only the public API and CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS is
#      incompatible with explicit dllexport - so force mingw ld to export every
#      symbol from the geos DLLs with -Wl,--export-all-symbols (overrides the
#      dllexport restriction), letting geos_c resolve the internals. Keeping GEOS
#      shared means PostGIS detects libgeos_c.dll the normal way (static geos
#      builds, but then PostGIS's configure link-test for libgeos_c can't pull
#      libgeos + libstdc++ and fails "could not find libgeos_c").
#  (2) PROJ's public C API is PROJ_DLL-exported, so EXPORT_ALL_SYMBOLS suffices.
#  (3) mingw's gcc 16 no longer pulls in <cstdint> transitively, so PROJ's Win32
#      filemanager.cpp fails on uint32_t - force-include it for PROJ.
WIN_EXPORT=""; GEOS_LINK=""; PROJ_CXXFLAGS=""
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*)
    WIN_EXPORT="-DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON"
    GEOS_LINK="-DCMAKE_SHARED_LINKER_FLAGS=-Wl,--export-all-symbols"
    PROJ_CXXFLAGS="-include cstdint"
    ;;
esac

echo "=== GEOS 3.13.0 ($(date +%H:%M:%S)) ==="
cd "$SRC/geos-3.13.0"
rm -rf build && mkdir build && cd build
cmake -G "Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX="$DEPS" \
  -DCMAKE_C_COMPILER="$CMAKE_CC" -DCMAKE_CXX_COMPILER="$CMAKE_CXX" $WIN_EXPORT \
  -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=OFF -DBUILD_DOCUMENTATION=OFF $GEOS_LINK \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 .. >"$LOG/dep-geos.log" 2>&1
make -j"$J" >>"$LOG/dep-geos.log" 2>&1
make install >>"$LOG/dep-geos.log" 2>&1
echo "geos: $("$DEPS/bin/geos-config" --version 2>/dev/null)"

echo "=== PROJ 9.5.1 ($(date +%H:%M:%S)) ==="
cd "$SRC/proj-9.5.1"
rm -rf build && mkdir build && cd build
# CXXFLAGS carries PROJ_CXXFLAGS (mingw <cstdint> fix); empty/no-op elsewhere.
CXXFLAGS="$PROJ_CXXFLAGS" cmake -G "Unix Makefiles" \
  -DCMAKE_INSTALL_PREFIX="$DEPS" \
  -DCMAKE_C_COMPILER="$CMAKE_CC" -DCMAKE_CXX_COMPILER="$CMAKE_CXX" $WIN_EXPORT \
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
