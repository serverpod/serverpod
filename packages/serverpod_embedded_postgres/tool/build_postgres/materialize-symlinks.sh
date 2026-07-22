#!/usr/bin/env bash
# Replace every symlink under <stage-dir> with a real copy of its target, or
# fail loudly - never silently skip. Windows packaging step: end-user
# extraction (Dart Link.createSync) needs the SeCreateSymbolicLink privilege
# regular Windows users don't have, so a Windows bundle must carry no
# symlinks at all. A link this script cannot materialize is a packaging
# error, not something to ship.
#
# Target resolution, per link (chains followed up to 32 hops):
#   1. Normal semantics: the target relative to the link's own directory.
#   2. The mingw PostGIS form: targets like `./share/...` are written
#      relative to the BUNDLE ROOT, unresolvable from the link's directory.
#      Interpreted relative to <stage-dir> instead.
# Both interpretations are confined to the stage: absolute targets and paths
# that resolve outside the stage are rejected. The bundle-root interpretation
# is reserved for the known `./share/...` form. There is deliberately NO
# basename fallback - it could silently copy a same-named file from an
# unrelated directory.
set -euo pipefail
STAGE="${1:?usage: materialize-symlinks.sh <stage-dir>}"

fail() { echo "materialize-symlinks: $*" >&2; exit 1; }

[ -d "$STAGE" ] || fail "$STAGE is not a directory"
STAGE="$(cd -P "$STAGE" && pwd)"

# Canonicalize an existing path's parent and reject it when an intermediate
# directory symlink or `..` component takes it outside the stage. The final
# component is left unresolved so a symlink chain can be followed explicitly.
inside_stage() {
  local path="$1" parent normalized
  parent="$(cd -P "$(dirname "$path")" 2>/dev/null && pwd)" || return 1
  normalized="$parent/$(basename "$path")"
  case "$normalized" in
    "$STAGE"/*) printf '%s\n' "$normalized" ;;
    *) fail "$path resolves outside the stage ($normalized)" ;;
  esac
}

# Resolves the symlink in $1 to the regular file it denotes and prints that
# file's path. Fails the script on absolute / escaping / cyclic targets;
# returns 1 when no interpretation yields an existing regular file.
resolve() {
  local link="$1" hops=0 target candidate next
  while [ "$hops" -lt 32 ]; do
    target="$(readlink "$link")"
    case "$target" in
      /*) fail "$link has an absolute target ($target)" ;;
    esac
    next=""
    candidate="$(inside_stage "$(dirname "$link")/$target")" || candidate=""
    if [ -n "$candidate" ] && { [ -e "$candidate" ] || [ -L "$candidate" ]; }; then
      next="$candidate"
    fi
    if [ -z "$next" ]; then
      case "$target" in
        ./share/*)
          candidate="$(inside_stage "$STAGE/${target#./}")" || candidate=""
          if [ -n "$candidate" ] && { [ -e "$candidate" ] || [ -L "$candidate" ]; }; then
            next="$candidate"
          fi
          ;;
      esac
    fi
    [ -n "$next" ] || return 1
    if [ -L "$next" ]; then
      link="$next"; hops=$((hops + 1)); continue
    fi
    [ -f "$next" ] || return 1
    printf '%s\n' "$next"
    return 0
  done
  fail "$1 exceeds 32 symlink hops (cycle?)"
}

# Snapshot the link list up front (mutating the tree mid-walk is undefined)
# and sort it so failures are deterministic regardless of filesystem order.
links="$(find "$STAGE" -type l | sort)"
count=0
while IFS= read -r link; do
  [ -n "$link" ] || continue
  file="$(resolve "$link")" || fail \
    "cannot materialize $link -> $(readlink "$link"): no interpretation of the target is a regular file inside $STAGE"
  rm -f "$link"
  cp "$file" "$link"
  count=$((count + 1))
done <<< "$links"

leftover="$(find "$STAGE" -type l)"
[ -z "$leftover" ] || fail "symlinks remain after materialization: $leftover"
echo "materialize-symlinks: materialized $count symlink(s) in $STAGE"
