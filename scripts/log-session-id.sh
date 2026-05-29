#!/usr/bin/env bash
# SessionStart hook: log session_id with timestamp + cwd to ~/.claude/session-log/sessions.log

set -euo pipefail

LOG_DIR="${HOME}/.claude/session-log"
LOG_FILE="${LOG_DIR}/sessions.log"

mkdir -p "$LOG_DIR"

payload=$(cat)
session_id=$(printf '%s' "$payload" | jq -r '.session_id // "unknown"')
source=$(printf '%s' "$payload" | jq -r '.source // "unknown"')
cwd=$(printf '%s' "$payload" | jq -r '.cwd // empty')
[ -z "$cwd" ] && cwd="$PWD"

ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
printf '%s\t%s\t%s\t%s\n' "$ts" "$session_id" "$source" "$cwd" >> "$LOG_FILE"
