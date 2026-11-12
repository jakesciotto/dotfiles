#!/usr/bin/env bash
# Symlink dotfiles into $HOME. Idempotent: safe to re-run.
# A real file at a target is backed up to <name>.pre-dotfiles, never clobbered.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$REPO/$1" dest="$HOME/$2"
    if [ ! -e "$src" ]; then
        echo "skip (missing source): $1" >&2
        return
    fi
    # ln -sfn against a real directory nests inside it instead of replacing it.
    if [ -d "$dest" ] && [ ! -L "$dest" ]; then
        echo "REFUSING: $dest is a real directory - move it aside first" >&2
        return 1
    fi
    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        mv "$dest" "$dest.pre-dotfiles"
        echo "backed up: $dest -> $dest.pre-dotfiles"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest"
    echo "linked: $dest -> $src"
}

# Remove a link this repo created at an old location. A real file there is
# left alone, because it is not ours to delete.
unlink_legacy() {
    local dest="$HOME/$1"
    [ -L "$dest" ] || return 0
    case "$(readlink "$dest")" in
        "$REPO"/*) rm "$dest"; echo "removed legacy link: $dest" ;;
        *) echo "left alone (not ours): $dest" >&2 ;;
    esac
}

# git and dircolors moved to ~/.config. Git reads ~/.config/git/config only
# when ~/.gitconfig does not exist, so the old link must go first.
unlink_legacy .gitconfig
unlink_legacy .gitconfig-posthog
unlink_legacy .gitconfig-signing
unlink_legacy .dir_colors

# Machine-local git config is untracked, so move it rather than link it.
if [ -f "$HOME/.gitconfig-local" ] && [ ! -e "$HOME/.config/git/local" ]; then
    mkdir -p "$HOME/.config/git"
    mv "$HOME/.gitconfig-local" "$HOME/.config/git/local"
    echo "moved: ~/.gitconfig-local -> ~/.config/git/local"
fi

link .zshrc .zshrc
link .zshenv .zshenv
link config/dircolors .config/dircolors
link config/git/config .config/git/config
link config/git/posthog .config/git/posthog

# Signing config only where the signing key exists. Without the key,
# commit.gpgsign=true breaks every commit, and git ignores a missing include.
if [ -f "$HOME/.ssh/id_ed25519_signing.pub" ]; then
    link config/git/signing .config/git/signing
else
    unlink_legacy .config/git/signing
fi
link .vimrc .vimrc

if [ "$(uname -s)" = "Darwin" ]; then
    mkdir -p "$HOME/.hammerspoon"
    link .hammerspoon/init.lua .hammerspoon/init.lua
    link config/iterm2/fleet.json "Library/Application Support/iTerm2/DynamicProfiles/fleet.json"
fi

# ---- Claude Code (~/.claude) ----
# Shared, public-safe parts link from config/claude. Box state stays real files:
# settings.json, settings.local.json, rules/, references/, memory/.
CLAUDE_DIR="$HOME/.claude"
SHARED_MARKER="$HOME/.config/claude/shared-settings"
mkdir -p "$CLAUDE_DIR"

# A path that still links into the retired claude-config becomes a real copy of its target.
detach_claude_config() {
    local dest="$CLAUDE_DIR/$1" tmp
    [ -L "$dest" ] || return 0
    case "$(readlink "$dest")" in *claude-config*) ;; *) return 0 ;; esac
    tmp="$dest.detach.$$"
    if [ -e "$dest" ]; then cp -RL "$dest" "$tmp"; else mkdir -p "$tmp"; fi
    rm "$dest"
    /bin/mv -f "$tmp" "$dest"
    echo "detached from claude-config: $dest"
}

# Link each child of a repo dir into a real dest dir. Other tools drop entries in
# skills/ and hooks/, so those stay real directories. A real child is never replaced.
link_claude_children() {
    local srcdir="$REPO/$1" destdir="$CLAUDE_DIR/$2" mode="${3:-}" child name dest
    [ -L "$destdir" ] && { rm "$destdir"; echo "migrated: $destdir symlink removed, now a real dir"; }
    mkdir -p "$destdir"
    for child in "$srcdir"/*; do
        [ -e "$child" ] || continue
        name="$(basename "$child")"; dest="$destdir/$name"
        if [ "$mode" = "--skills-only" ] && [ ! -f "$child/SKILL.md" ]; then continue; fi
        if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            echo "REFUSING: $dest is a real file or dir - move it aside first" >&2
            continue
        fi
        ln -sfn "$child" "$dest"
        echo "linked: $dest -> $child"
    done
}

# A box whose settings.json was the shared claude-config file keeps sharing.
case "$(readlink "$CLAUDE_DIR/settings.json" 2>/dev/null)" in
    *claude-config*) mkdir -p "$(dirname "$SHARED_MARKER")"; touch "$SHARED_MARKER" ;;
esac
for p in settings.json references commands; do detach_claude_config "$p"; done
case "$(readlink "$CLAUDE_DIR/scripts" 2>/dev/null)" in
    *claude-config*) rm "$CLAUDE_DIR/scripts"; echo "removed claude-config link: $CLAUDE_DIR/scripts" ;;
esac

link config/claude/CLAUDE.md .claude/CLAUDE.md
link config/claude/agents .claude/agents
mkdir -p "$CLAUDE_DIR/scripts" "$CLAUDE_DIR/commands" "$CLAUDE_DIR/references"
link config/claude/statusline-usage.py .claude/scripts/statusline-usage.py
link_claude_children config/claude/skills skills --skills-only
link_claude_children config/claude/hooks hooks

# Any remaining link into claude-config (an old skill or hook) is stale.
find "$CLAUDE_DIR/skills" "$CLAUDE_DIR/hooks" -maxdepth 1 -type l -lname '*claude-config*' -print 2>/dev/null \
    | while read -r l; do rm "$l"; echo "removed stale claude-config link: $l"; done

# Memory rules are live box state: seed the template once, never clobber.
mkdir -p "$CLAUDE_DIR/rules"
for f in "$REPO"/config/claude/rules/*.md; do
    dest="$CLAUDE_DIR/rules/$(basename "$f")"
    if [ -e "$dest" ]; then echo "kept (live): $dest"; else cp "$f" "$dest"; echo "seeded: $dest"; fi
done

# The SessionEnd hooks source this file for Supabase creds. It is never in git.
hook_env="$CLAUDE_DIR/hooks/.session-summary.env"
if [ ! -f "$hook_env" ]; then
    ( umask 077; printf 'SUPABASE_URL=\nSUPABASE_SERVICE_KEY=\n' >"$hook_env" )
    echo "ACTION REQUIRED: set SUPABASE_URL and SUPABASE_SERVICE_KEY in $hook_env - the SessionEnd hooks no-op until then" >&2
fi

# host.name labels Grafana series and the prompt. Seed on a fresh box only.
local_settings="$CLAUDE_DIR/settings.local.json"
if [ ! -f "$local_settings" ]; then
    printf '{\n  "env": {\n    "OTEL_RESOURCE_ATTRIBUTES": "host.name=%s"\n  }\n}\n' "${CLAUDE_BOX:-$(hostname -s)}" >"$local_settings"
    echo "seeded: $local_settings (host.name from hostname - verify it is the fleet name)"
fi

# settings.json belongs to this box. A box that had none joins the shared layer;
# a box opts in or out later by creating or deleting $SHARED_MARKER.
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
    mkdir -p "$(dirname "$SHARED_MARKER")"; touch "$SHARED_MARKER"
fi
if [ -f "$SHARED_MARKER" ]; then
    "$REPO/config/claude/apply-shared-settings.sh"
else
    echo "shared Claude settings: off on this box (touch $SHARED_MARKER to opt in)"
fi

echo "done. open a new shell and restart any running Claude Code session."
