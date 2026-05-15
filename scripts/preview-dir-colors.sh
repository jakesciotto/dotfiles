#!/usr/bin/env bash
# Preview every rule in .dir_colors by printing the pattern with its ANSI code applied.
# Usage: ./scripts/preview-dir-colors.sh [path/to/.dir_colors]

set -euo pipefail

FILE="${1:-$(dirname "$0")/../.dir_colors}"

if [[ ! -f "$FILE" ]]; then
  echo "dir_colors file not found: $FILE" >&2
  exit 1
fi

RESET=$'\033[0m'

while IFS= read -r line; do
  # Section header lines like "# :: 1. Archives ..."
  if [[ "$line" =~ ^#[[:space:]]*::[[:space:]]*(.+)$ ]]; then
    printf '\n\033[1;4m%s%s\n' "${BASH_REMATCH[1]}" "$RESET"
    continue
  fi

  # Skip comments, blanks, TERM, OPTIONS, COLOR, EIGHTBIT
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
  [[ "$line" =~ ^(TERM|OPTIONS|COLOR|EIGHTBIT)[[:space:]] ]] && continue

  # Strip inline comment, then split into pattern + code
  stripped="${line%%#*}"
  pattern="$(awk '{print $1}' <<< "$stripped")"
  code="$(awk '{print $2}' <<< "$stripped")"

  [[ -z "$pattern" || -z "$code" ]] && continue

  printf '  \033[%sm%-28s%s  %s\n' "$code" "$pattern" "$RESET" "$code"
done < "$FILE"
