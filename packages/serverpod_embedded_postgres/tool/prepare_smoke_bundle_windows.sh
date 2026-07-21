#!/usr/bin/env bash
# Prepares the writable workspace and command wrapper used to run the Windows
# bundle smoke test through PsExec's limited token.
#
# Kept next to smoke_bundle_windows.sh because this is CI smoke-test plumbing,
# not a bundle build input. Changes here must not invalidate the recipe hash.
set -euo pipefail

LAUNCHER="${1:?usage: prepare_smoke_bundle_windows.sh <launcher.cmd>}"
: "${RUNNER_TEMP:?RUNNER_TEMP must be set}"
: "${GITHUB_WORKSPACE:?GITHUB_WORKSPACE must be set}"

RUNNER_TEMP_MSYS="$(cygpath -u "$RUNNER_TEMP")"
SMOKE_WORK_MSYS="$RUNNER_TEMP_MSYS/smoke-work"
SMOKE_WORK_WIN="$(cygpath -w "$SMOKE_WORK_MSYS")"
SMOKE_LOG_WIN="$(cygpath -w "$SMOKE_WORK_MSYS/smoke.log")"

MSYS2_CMD_WIN="$(cygpath -w "$RUNNER_TEMP_MSYS/setup-msys2/msys2.cmd")"
SMOKE_SCRIPT_MSYS="$(cygpath -u "$GITHUB_WORKSPACE")/packages/serverpod_embedded_postgres/tool/smoke_bundle_windows.sh"
BUNDLE_MSYS="$RUNNER_TEMP_MSYS/smoke-bundle"

# PsExec -l uses a Low Integrity token, so it cannot write to the runner's
# regular temporary directory. This is the only writable tree it needs.
mkdir -p "$SMOKE_WORK_MSYS"
rm -f "$SMOKE_WORK_MSYS/smoke.log"
MSYS2_ARG_CONV_EXCL='*' icacls.exe "$SMOKE_WORK_WIN" \
  /setintegritylevel '(OI)(CI)L'

cat > "$LAUNCHER" <<EOF
@echo off
set "TEMP=$SMOKE_WORK_WIN"
set "TMP=$SMOKE_WORK_WIN"
set "TMPDIR=$SMOKE_WORK_MSYS"
call "$MSYS2_CMD_WIN" ^
  "$SMOKE_SCRIPT_MSYS" ^
  "$BUNDLE_MSYS" ^
  > "$SMOKE_LOG_WIN" 2>&1
exit /b %errorlevel%
EOF
