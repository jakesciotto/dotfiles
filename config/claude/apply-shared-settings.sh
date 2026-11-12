#!/usr/bin/env bash
# Merge settings.shared.json into this box's ~/.claude/settings.json.
# Shared values win, arrays are unioned, and keys only the box has are kept.
# Runtime keys that Claude Code writes (model, effort, auto-mode survey) are never shared.
#
#   apply-shared-settings.sh          apply
#   apply-shared-settings.sh --check  exit 1 and name the keys when the box file differs
set -euo pipefail

SHARED="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/settings.shared.json"
LIVE="$HOME/.claude/settings.json"
RUNTIME='["model","modelSettings","effortLevel","autoMode"]'

command -v jq >/dev/null || { echo "jq not found: shared Claude settings not applied" >&2; exit 0; }
[ -L "$LIVE" ] && { echo "REFUSING: $LIVE is a symlink, run dotfiles/install.sh first" >&2; exit 1; }
[ -f "$LIVE" ] || echo '{}' >"$LIVE"

merged=$(jq --slurpfile s "$SHARED" --argjson rt "$RUNTIME" '
  def merge($a; $b):
    if ($a|type) == "object" and ($b|type) == "object" then
      reduce ($b|keys_unsorted[]) as $k ($a; .[$k] = (if has($k) then merge(.[$k]; $b[$k]) else $b[$k] end))
    elif ($a|type) == "array" and ($b|type) == "array" then $a + ($b - $a)
    else $b end;
  merge(.; $s[0] | delpaths([$rt[] | [.]]))
' "$LIVE")

if [ "${1:-}" = "--check" ]; then
    diff_keys=$(jq -rn --argjson a "$(cat "$LIVE")" --argjson b "$merged" \
        '[($a|keys) + ($b|keys) | unique | .[] | select($a[.] != $b[.])] | join(", ")')
    [ -z "$diff_keys" ] && exit 0
    echo "$diff_keys"
    exit 1
fi

if [ "$merged" = "$(jq . "$LIVE")" ]; then
    echo "shared Claude settings: already applied"
    exit 0
fi
cp "$LIVE" "$LIVE.pre-shared"
printf '%s\n' "$merged" >"$LIVE.tmp" && mv -f "$LIVE.tmp" "$LIVE"
echo "shared Claude settings: applied (previous file at $LIVE.pre-shared)"
