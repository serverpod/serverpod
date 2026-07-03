#!/usr/bin/env bash
# Smoke-test a built embedded-postgres bundle: initdb -> start -> load pgvector +
# PostGIS -> write and read a row that exercises both -> stop. Catches a bundle
# that unpacks but cannot actually run - unresolved shared libs (e.g. PostGIS not
# finding libgeos after relocation) or a backend codegen fault (e.g. an arm64
# build that segfaults on INSERT) - i.e. failures that only surface once the
# server runs a real query, before such a bundle is published.
#
#   smoke_bundle.sh <extracted-bundle-dir>   # dir containing bin/ lib/ share/
#
# Unix only (macOS/Linux); Windows bundles are validated separately. Kept out of
# tool/build_postgres/ on purpose: it is a post-build check, not a build input,
# so it must not perturb the build-recipe cache key.
set -euo pipefail

BUNDLE="${1:?usage: smoke_bundle.sh <extracted-bundle-dir>}"
BIN="$BUNDLE/bin"
[ -x "$BIN/postgres" ] || { echo "smoke: $BIN/postgres missing or not executable" >&2; exit 1; }

# PostGIS finds its coordinate data via PROJ_LIB (the runtime launcher sets the
# same). Shared libs resolve via the bundle's baked rpaths/install_names - no
# LD_LIBRARY_PATH / DYLD_* needed; if that is broken, CREATE EXTENSION fails here.
export PROJ_LIB="$BUNDLE/share/proj"

# Relocatability gate (Linux): a run-the-server check alone can lie - a host
# with system libpq/libgeos (GitHub runners have both) resolves what a missing
# $ORIGIN rpath doesn't, and on the build host the baked absolute build-tree
# rpath still exists. Assert every dep resolves AND the bundled ones resolve
# into THIS bundle.
if [ "$(uname -s)" = Linux ]; then
  echo "smoke: relocatability (ldd)"
  check_reloc() {
    local out
    out="$(ldd "$1")"
    if echo "$out" | grep -q 'not found'; then
      echo "smoke: $1 has unresolved libs:" >&2
      echo "$out" | grep 'not found' >&2
      return 1
    fi
    if echo "$out" | grep -E 'libpq|libgeos|libproj' | grep -qv "$BUNDLE"; then
      echo "smoke: $1 resolves bundled libs outside the bundle:" >&2
      echo "$out" | grep -E 'libpq|libgeos|libproj' | grep -v "$BUNDLE" >&2
      return 1
    fi
  }
  check_reloc "$BIN/initdb"
  check_reloc "$BIN/postgres"
  check_reloc "$BUNDLE/lib/postgresql/postgis-3.so"
fi

WORK="$(mktemp -d)"
DATA="$WORK/data"
# A long temp path overflows the ~104-char unix-socket sun_path; keep it short.
SOCK="$(mktemp -d "/tmp/pgsmoke.XXXXXX")"
PORT="${SMOKE_PG_PORT:-15499}"

finish() {
  local rc=$?
  if [ "$rc" -ne 0 ] && [ -f "$DATA/server.log" ]; then
    echo "=== postgres server.log ==="; cat "$DATA/server.log"
  fi
  "$BIN/pg_ctl" -D "$DATA" -m immediate stop >/dev/null 2>&1 || true
  rm -rf "$WORK" "$SOCK" 2>/dev/null || true
}
trap finish EXIT

echo "smoke: initdb"
"$BIN/initdb" -D "$DATA" -U postgres --auth=trust --encoding=UTF8 >/dev/null

echo "smoke: start postgres (unix socket only, port $PORT)"
"$BIN/pg_ctl" -D "$DATA" -w -t 60 -l "$DATA/server.log" \
  -o "-p $PORT -k $SOCK -c listen_addresses=''" start

run_sql() {
  "$BIN/psql" -v ON_ERROR_STOP=1 -h "$SOCK" -p "$PORT" -U postgres -d postgres -X -q "$@"
}

echo "smoke: load extensions + write/read"
run_sql <<'SQL'
CREATE EXTENSION vector;
CREATE EXTENSION postgis;
-- halfvec exercises pgvector's _Float16 code paths, which have miscompiled
-- on mingw before. Mirrors the serverpod test migration's shape.
CREATE TABLE smoke_half (id int PRIMARY KEY, h halfvec(3));
CREATE INDEX ON smoke_half USING hnsw (h halfvec_l2_ops);
INSERT INTO smoke_half VALUES (1, '[1,2,3]'), (2, '[4,5,6]');
SELECT id, h <-> '[1,2,4]' AS dist, l2_normalize(h) FROM smoke_half ORDER BY dist;
CREATE TABLE smoke (id int PRIMARY KEY, v vector(3), g geometry(Point, 4326));
INSERT INTO smoke VALUES (1, '[1,2,3]', ST_SetSRID(ST_MakePoint(1, 2), 4326));
SELECT id, v <-> '[1,2,4]' AS dist, ST_AsText(g) AS pt, postgis_version() FROM smoke;
SQL

echo "smoke: OK -- $("$BIN/postgres" --version)"
