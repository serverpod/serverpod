#!/usr/bin/env bash
# Windows variant of smoke_bundle.sh (which is unix-socket only): boots the
# bundle on TCP localhost and runs the same extension + write/read battery.
# Runs under an MSYS2 bash on the CI runner.
#
# Like smoke_bundle.sh, kept out of tool/build_postgres/ on purpose: it is a
# post-build check, not a build input, so it must not perturb the build-recipe
# cache key.
set -euo pipefail

BUNDLE="${1:?usage: smoke_bundle_windows.sh <extracted-bundle-dir>}"
BIN="$BUNDLE/bin"
[ -x "$BIN/postgres.exe" ] || { echo "smoke: $BIN/postgres.exe missing" >&2; exit 1; }

export PROJ_LIB="$BUNDLE/share/proj"

WORK="$(mktemp -d)"
DATA="$WORK/data"
PORT="${SMOKE_PG_PORT:-15499}"

finish() {
  local rc=$?
  if [ "$rc" -ne 0 ] && [ -f "$DATA/server.log" ]; then
    echo "=== postgres server.log ==="; cat "$DATA/server.log"
  fi
  "$BIN/pg_ctl" -D "$DATA" -m immediate stop >/dev/null 2>&1 || true
  rm -rf "$WORK" 2>/dev/null || true
}
trap finish EXIT

echo "smoke: initdb"
"$BIN/initdb" -D "$DATA" -U postgres --auth=trust --encoding=UTF8 >/dev/null

echo "smoke: start postgres (127.0.0.1:$PORT)"
"$BIN/pg_ctl" -D "$DATA" -w -t 60 -l "$DATA/server.log" \
  -o "-p $PORT -c listen_addresses=127.0.0.1" start

run_sql() {
  "$BIN/psql" -v ON_ERROR_STOP=1 -h 127.0.0.1 -p "$PORT" -U postgres -d postgres -X -q "$@"
}

echo "smoke: load extensions + write/read (vector, halfvec, PostGIS)"
run_sql <<'SQL'
CREATE EXTENSION vector;
CREATE EXTENSION postgis;
-- halfvec is mingw-compiled _Float16 code that no CI test suite executes on
-- windows; it has miscompiled before (backend ud2 crash on user machines).
-- Mirrors the serverpod test migration's shape: hnsw index + real data.
CREATE TABLE smoke_half (id int PRIMARY KEY, h halfvec(3));
CREATE INDEX ON smoke_half USING hnsw (h halfvec_l2_ops);
INSERT INTO smoke_half VALUES (1, '[1,2,3]'), (2, '[4,5,6]');
SELECT id, h <-> '[1,2,4]' AS dist, l2_normalize(h) FROM smoke_half ORDER BY dist;
CREATE TABLE smoke (id int PRIMARY KEY, v vector(3), g geometry(Point, 4326));
INSERT INTO smoke VALUES (1, '[1,2,3]', ST_SetSRID(ST_MakePoint(1, 2), 4326));
SELECT id, v <-> '[1,2,4]' AS dist, ST_AsText(g) AS pt, postgis_version() FROM smoke;
SQL

echo "smoke: OK -- $("$BIN/postgres" --version)"
