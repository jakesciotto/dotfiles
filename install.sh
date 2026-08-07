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
    ln -sfn "$src" "$dest"
    echo "linked: $dest -> $src"
}

link .zshrc .zshrc
link .dir_colors .dir_colors
link .gitconfig .gitconfig
link .gitconfig-posthog .gitconfig-posthog
link .gitconfig-signing .gitconfig-signing
link .vimrc .vimrc

if [ "$(uname -s)" = "Darwin" ]; then
    mkdir -p "$HOME/.hammerspoon"
    link .hammerspoon/init.lua .hammerspoon/init.lua
fi

echo "done. open a new shell."
