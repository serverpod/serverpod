#!/usr/bin/env bash
# Build PostGIS 3.5.4 against the zig-built postgres + the static dep chain.
set -euo pipefail
B="${PGBUILD:-$HOME/pgzig}"; DEPS="$B/deps"; SRC="$B/src"; PREFIX="$B/out/pg"; LOG="$B/logs"; mkdir -p "$LOG"
WCC="$B/shim/cc"; WCXX="$B/shim/cxx"
export PATH="$DEPS/bin:$PREFIX/bin:$PATH"
J="$(getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)"

cd "$SRC/postgis-3.5.4"
make distclean >/dev/null 2>&1 || true

export CC="$WCC" CXX="$WCXX"
export CPPFLAGS="-I$DEPS/include"
export LDFLAGS="-L$DEPS/lib -Wl,-rpath,$DEPS/lib"
# GEOS/PROJ are shared dylibs (each embeds its own C++ impl + libc++, and PROJ
# embeds static sqlite3), so the postgis-3.so link resolves -lgeos_c/-lproj on
# their own. PostGIS's PROJ-version conftest uses $LIBS but drops $LDFLAGS, so
# fold -L and the rpath into LIBS too; -lproj satisfies that version probe.
export LIBS="-L$DEPS/lib -Wl,-rpath,$DEPS/lib -lproj"

echo "=== configure ($(date +%H:%M:%S)) ==="
# --prefix governs PostGIS's OWN files (loader tools, man pages, headers); the
# extension itself installs into the PG tree via pg_config regardless. Without
# it --prefix defaults to /usr/local, so `make install`'s man-install hits a
# permission-denied writing /usr/local/share/man on CI. Point it at our writable
# install tree.
#
# --without-address-standardizer: that extension #includes the system <pcre2.h>,
# which the Linux glibc-target wrapper (zig uses its own sysroot, not
# /usr/include) can't find -> compile fails on parseaddress-api.c. We don't ship
# US-address normalization, so disable it everywhere; this also short-circuits
# PostGIS's PCRE detection entirely.
#
# --disable-nls: PostGIS enables NLS by default (USE_NLS=yes), so its
# postgis_config.h defines ENABLE_NLS -> the server c.h then `#include
# <libintl.h>`, which isn't on Apple clang's default include path (gettext is
# keg-only on macOS). We ship English-only, so turn it off (pairs with core's).
./configure \
  --prefix="$PREFIX" \
  --with-pgconfig="$PREFIX/bin/pg_config" \
  --with-projdir="$DEPS" \
  --with-geosconfig="$DEPS/bin/geos-config" \
  --with-xml2config="$DEPS/bin/xml2-config" \
  --with-jsondir="$DEPS" \
  --without-raster --without-protobuf --without-address-standardizer \
  --disable-nls \
  >"$LOG/postgis-conf.log" 2>&1 && echo "configure OK" || { echo "configure FAIL"; tail -n 30 "$LOG/postgis-conf.log"; exit 1; }

# flatgeobuf builds its static lib with `ar rs libflatgeobuf.la` - a real ar
# archive misnamed .la. The system linker keys off content, but zig's linker
# rejects by extension. Rename to .a across the generated Makefiles.
find . -name Makefile -exec sed -i.bak 's#libflatgeobuf\.la#libflatgeobuf.a#g' {} +

# Serial build: PostGIS's extension/upgrade SQL generation has undeclared
# inter-target deps and races under `make -j` (parallel recipes clobber a shared
# rtpostgis.sql.tmp -> "Unable to locate target new version number"). -j1 on the
# command line overrides the -j MAKEFLAGS that build-all.sh exports - a bare
# `make` inherits it and still races (only timing-luck spared macOS/Linux). The
# C compile is cheap here (GEOS/PROJ already built), so serial is a fine trade.
echo "=== make ($(date +%H:%M:%S)) ==="
make -j1 >"$LOG/postgis-make.log" 2>&1 && echo "make OK" || { echo "make FAIL"; tail -n 40 "$LOG/postgis-make.log"; exit 1; }
make -j1 install >>"$LOG/postgis-make.log" 2>&1 && echo "install OK" || { echo "install FAIL"; tail -n 20 "$LOG/postgis-make.log"; exit 1; }

echo "=== installed postgis modules ($(date +%H:%M:%S)) ==="
ls "$PREFIX/lib/postgresql"/postgis* 2>/dev/null | sed 's#.*/##'
ls "$PREFIX/share/postgresql/extension"/postgis*.control 2>/dev/null | sed 's#.*/##'
