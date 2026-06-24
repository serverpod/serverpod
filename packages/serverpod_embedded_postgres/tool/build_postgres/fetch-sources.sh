#!/usr/bin/env bash
# Download + extract all upstream sources into $PGBUILD/src.
# Pinned versions (keep in sync with the package's defaultPostgresVersion and
# the README): PostgreSQL 16.13, pgvector 0.8.3, PostGIS 3.5.4,
# GEOS 3.13.0, PROJ 9.5.1, SQLite 3.47.2, libxml2 2.13.8, json-c 0.18.
set -euo pipefail
B="${PGBUILD:-$HOME/pgzig}"; SRC="$B/src"; mkdir -p "$SRC"; cd "$SRC"

dl() { [ -f "$2" ] || curl -fsSL -o "$2" "$1"; }
dl https://ftp.postgresql.org/pub/source/v16.13/postgresql-16.13.tar.bz2     postgresql-16.13.tar.bz2
dl https://github.com/pgvector/pgvector/archive/refs/tags/v0.8.3.tar.gz      pgvector-0.8.3.tar.gz
dl https://www.sqlite.org/2024/sqlite-autoconf-3470200.tar.gz                sqlite.tar.gz
dl https://download.gnome.org/sources/libxml2/2.13/libxml2-2.13.8.tar.xz     libxml2.tar.xz
dl https://s3.amazonaws.com/json-c_releases/releases/json-c-0.18.tar.gz      json-c.tar.gz
dl https://download.osgeo.org/proj/proj-9.5.1.tar.gz                         proj.tar.gz
dl https://download.osgeo.org/geos/geos-3.13.0.tar.bz2                       geos.tar.bz2
dl https://download.osgeo.org/postgis/source/postgis-3.5.4.tar.gz            postgis.tar.gz

[ -d postgresql-16.13 ]        || tar xjf postgresql-16.13.tar.bz2
[ -d pgvector-0.8.3 ]          || tar xzf pgvector-0.8.3.tar.gz
[ -d sqlite-autoconf-3470200 ] || tar xzf sqlite.tar.gz
[ -d libxml2-2.13.8 ]          || tar xJf libxml2.tar.xz
# json-c ships symlinked test fixtures (tests/*.test -> test_basic.test) that
# MSYS2 tar can't recreate on Windows (no symlink privilege) -> extraction
# aborts. We build json-c with -DBUILD_TESTING=OFF, so the tests are dead weight;
# excluding them is harmless on every platform and unblocks the Windows build.
[ -d json-c-0.18 ]             || tar --exclude='json-c-0.18/tests/*' -xzf json-c.tar.gz
[ -d proj-9.5.1 ]              || tar xzf proj.tar.gz
[ -d geos-3.13.0 ]             || tar xjf geos.tar.bz2
[ -d postgis-3.5.4 ]           || tar xzf postgis.tar.gz

echo "sources ready in $SRC"
