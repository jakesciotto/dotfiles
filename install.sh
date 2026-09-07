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

echo "done. open a new shell."
