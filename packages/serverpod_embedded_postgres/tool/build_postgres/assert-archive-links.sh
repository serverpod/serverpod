#!/usr/bin/env bash
# Verify that a completed bundle archive contains only link entry types the
# runtime extractor can reproduce faithfully. Hardlinks are always forbidden;
# Windows bundles additionally forbid symlinks.
set -euo pipefail

ARCHIVE="${1:?usage: assert-archive-links.sh <archive> [--forbid-symlinks]}"
MODE="${2:-}"

fail() { echo "assert-archive-links: $*" >&2; exit 1; }

[ -f "$ARCHIVE" ] || fail "$ARCHIVE is not a file"
case "$MODE" in
  ""|--forbid-symlinks) ;;
  *) fail "unknown option: $MODE" ;;
esac

# GNU tar and bsdtar both use the first verbose-listing character as the entry
# type (`h` for a hardlink and `l` for a symlink).
listing="$(tar -tvf "$ARCHIVE")"
forbidden="$(awk 'substr($0,1,1)=="h"' <<< "$listing")"
if [ "$MODE" = "--forbid-symlinks" ]; then
  symlinks="$(awk 'substr($0,1,1)=="l"' <<< "$listing")"
  forbidden="$forbidden${symlinks:+${forbidden:+
}$symlinks}"
fi

[ -z "$forbidden" ] || {
  echo "assert-archive-links: $ARCHIVE contains forbidden link entries:" >&2
  echo "$forbidden" >&2
  exit 1
}

echo "assert-archive-links: $ARCHIVE satisfies the archive link policy"
