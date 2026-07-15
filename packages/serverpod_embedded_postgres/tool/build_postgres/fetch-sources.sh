#!/usr/bin/env bash
# Download + extract all upstream sources into $PGBUILD/src. Every version
# comes from versions.env (the canonical bundle spec) - nothing is hardcoded
# here, so a version bump cannot produce sources that disagree with the
# declared bundle identity.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=versions.env
. "$HERE/versions.env"
B="${PGBUILD:-$HOME/pgzig}"; SRC="$B/src"; mkdir -p "$SRC"; cd "$SRC"

# dl <url> <file> <sha256>: cached download + mandatory hash verification (a
# cached file is re-verified too, so a corrupted or tampered archive can't
# survive between runs). shasum fallback covers macOS, which has no sha256sum.
dl() {
  [ -f "$2" ] || curl -fsSL -o "$2" "$1"
  local actual
  actual="$( (command -v sha256sum >/dev/null 2>&1 && sha256sum "$2" || shasum -a 256 "$2") | awk '{print $1}')"
  [ "$actual" = "$3" ] || {
    echo "fetch: sha256 mismatch for $2" >&2
    echo "  expected $3" >&2
    echo "  actual   $actual" >&2
    exit 1
  }
}
dl "https://ftp.postgresql.org/pub/source/v$PG_UPSTREAM_VERSION/postgresql-$PG_UPSTREAM_VERSION.tar.bz2" "postgresql-$PG_UPSTREAM_VERSION.tar.bz2" "$PG_SHA256"
dl "https://github.com/pgvector/pgvector/archive/refs/tags/v$PGVECTOR_VERSION.tar.gz" "pgvector-$PGVECTOR_VERSION.tar.gz" "$PGVECTOR_SHA256"
dl "https://www.sqlite.org/$SQLITE_YEAR/sqlite-autoconf-$SQLITE_AUTOCONF.tar.gz" sqlite.tar.gz "$SQLITE_SHA256"
dl "https://download.gnome.org/sources/libxml2/${LIBXML2_VERSION%.*}/libxml2-$LIBXML2_VERSION.tar.xz" libxml2.tar.xz "$LIBXML2_SHA256"
dl "https://s3.amazonaws.com/json-c_releases/releases/json-c-$JSONC_VERSION.tar.gz" json-c.tar.gz "$JSONC_SHA256"
dl "https://download.osgeo.org/proj/proj-$PROJ_VERSION.tar.gz" proj.tar.gz "$PROJ_SHA256"
dl "https://download.osgeo.org/geos/geos-$GEOS_VERSION.tar.bz2" geos.tar.bz2 "$GEOS_SHA256"
dl "https://download.osgeo.org/postgis/source/postgis-$POSTGIS_VERSION.tar.gz" postgis.tar.gz "$POSTGIS_SHA256"

[ -d "postgresql-$PG_UPSTREAM_VERSION" ]      || tar xjf "postgresql-$PG_UPSTREAM_VERSION.tar.bz2"
[ -d "pgvector-$PGVECTOR_VERSION" ]           || tar xzf "pgvector-$PGVECTOR_VERSION.tar.gz"
[ -d "sqlite-autoconf-$SQLITE_AUTOCONF" ]     || tar xzf sqlite.tar.gz
[ -d "libxml2-$LIBXML2_VERSION" ]             || tar xJf libxml2.tar.xz
# json-c ships symlinked test fixtures (tests/*.test -> test_basic.test) that
# MSYS2 tar can't recreate on Windows (no symlink privilege) -> extraction
# aborts. We build json-c with -DBUILD_TESTING=OFF, so the tests are dead weight;
# excluding them is harmless on every platform and unblocks the Windows build.
[ -d "json-c-$JSONC_VERSION" ]                || tar --exclude="json-c-$JSONC_VERSION/tests/*" -xzf json-c.tar.gz
[ -d "proj-$PROJ_VERSION" ]                   || tar xzf proj.tar.gz
[ -d "geos-$GEOS_VERSION" ]                   || tar xjf geos.tar.bz2
[ -d "postgis-$POSTGIS_VERSION" ]             || tar xzf postgis.tar.gz

echo "sources ready in $SRC"
