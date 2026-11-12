#!/usr/bin/env bash
# SessionStart hook: one DRIFT line per problem, silence when clean.
# Covers dotfiles, dotfiles-private where it exists, and the ~/.claude install on this box.
# stdout lands in session context, so keep it short.

# Skip inside hook-spawned headless sessions.
if [ -n "${CLAUDE_CRITIC_RUNNING:-}" ] || [ -n "${CLAUDE_SUMMARY_RUNNING:-}" ] || [ -n "${CLAUDE_DECISIONS_RUNNING:-}" ]; then
  exit 0
fi

warn() { echo "DRIFT: $*"; }

check_repo() {
    local repo="$1" name counts ahead behind tmo=""
    name=$(basename "$repo")
    [ -d "$repo/.git" ] || { warn "$name missing at $repo"; return; }
    [ -n "$(git -C "$repo" status --porcelain)" ] && warn "$name has uncommitted changes"
    # Fetch at most once a day, never let a dead network stall session start.
    if [ ! -f "$repo/.git/FETCH_HEAD" ] || [ -n "$(find "$repo/.git/FETCH_HEAD" -mmin +1440 2>/dev/null)" ]; then
        command -v timeout  >/dev/null && tmo="timeout 5"
        command -v gtimeout >/dev/null && tmo="gtimeout 5"
        GIT_TERMINAL_PROMPT=0 $tmo git -C "$repo" fetch -q origin 2>/dev/null || true
    fi
    counts=$(git -C "$repo" rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null) || return 0
    read -r behind ahead <<< "$counts"
    [ "${behind:-0}" != "0" ] && warn "$name is $behind commit(s) behind origin - pull and rerun its installer"
    [ "${ahead:-0}" != "0" ] && warn "$name is $ahead commit(s) ahead of origin - push"
}

check_repo "$HOME/github/dotfiles"
[ -d "$HOME/github/dotfiles-private" ] && check_repo "$HOME/github/dotfiles-private"

stale=$(find "$HOME/.claude" -maxdepth 2 -type l -lname '*claude-config*' 2>/dev/null | head -3 | tr '\n' ' ')
[ -n "$stale" ] && warn "~/.claude still links into the retired claude-config ($stale) - run dotfiles/install.sh"

# settings.json is a real file on every box. A box opts into the shared layer with the marker file.
if [ -L "$HOME/.claude/settings.json" ]; then
    warn "~/.claude/settings.json is a symlink - run dotfiles/install.sh to make it this box's own file"
elif [ -f "$HOME/.config/claude/shared-settings" ]; then
    keys=$("$HOME/github/dotfiles/config/claude/apply-shared-settings.sh" --check 2>/dev/null) \
        || warn "~/.claude/settings.json differs from settings.shared.json on: $keys - move the change into the shared file, or rerun install.sh to reset it"
fi

[ -L "$HOME/.zshrc" ] || warn "~/.zshrc is not a symlink - run dotfiles/install.sh"
[ -L "$HOME/.zshenv" ] || warn "~/.zshenv is not a symlink - link dotfiles/.zshenv; it exports the OTLP endpoint since 2.1.282"
grep -q 'OTEL_EXPORTER_OTLP_ENDPOINT' "$HOME/.zshenv" 2>/dev/null || warn "no OTLP endpoint in ~/.zshenv - metrics drop to localhost silently"

f="$HOME/.claude/settings.local.json"
if [ ! -f "$f" ]; then
    warn "settings.local.json missing - Grafana series unlabeled; rerun dotfiles/install.sh"
else
    grep -q 'host\.name=' "$f" || warn "no host.name in settings.local.json - Grafana series unlabeled"
    grep -q 'OTEL_EXPORTER_OTLP_ENDPOINT' "$f" && warn "OTLP endpoint still in settings.local.json - 2.1.282+ ignores it and prints a startup notice; remove the key"
fi

exit 0
