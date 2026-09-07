# dotfiles

Shared shell and git config for the four-box fleet: `m5pro` and `m4max` (macOS), `vinelab` and `fedora` (Linux). All zsh.

`install.sh` symlinks everything into `$HOME` (idempotent; a real file at a target is backed up to `<name>.pre-dotfiles`). Files that support `~/.config` live there instead, to keep `$HOME` less crowded.

```
git clone https://github.com/jakesciotto/dotfiles ~/github/dotfiles
~/github/dotfiles/install.sh
```

## Structure

- `.zshrc` -- shared core: fleet identity + prompt, aliases, functions. Sources the OS layer, then an optional host layer.
- `os/darwin.zsh`, `os/linux.zsh` -- OS-specific: brew and g-prefixed coreutils vs native GNU tools.
- `hosts/<box>.zsh` -- optional per-box one-offs, sourced last. Intentional divergence goes here, tracked, instead of hand-edits on the box.
- `config/dircolors` -- terminal colorization rules (256-color), shared by both `gdircolors` (mac) and `dircolors` (linux). Links to `~/.config/dircolors`; the OS layers pass that path explicitly.
- `config/git/config` -- identity + per-repo PostHog includes. Personal (gmail) is the default on every box; work dirs override via `includeIf`.
- `config/git/posthog` -- work identity include for PostHog repo dirs.
- `config/git/signing` -- SSH commit signing. `install.sh` links it only when `~/.ssh/id_ed25519_signing.pub` exists on the box; `config/git/config` loads it with a plain `include`, and git ignores the missing file everywhere else. A box without the key never sees `commit.gpgsign=true`.
- `~/.config/git/local` -- machine-local include, never tracked: credential helpers (`gh auth git-credential` paths differ per box) and any box-specific overrides.
- `.vimrc` -- yanked a good .vimrc from online
- `.hammerspoon/init.lua` -- mac only; binds `Cmd+Shift+V` to clean-paste (strips leading whitespace from clipboard before pasting)
- `config/iterm2/fleet.json` -- mac only; iTerm2 Dynamic Profile named `Fleet`: Menlo 11, `xterm-256color`, `Cmd+Backspace` sends `Ctrl-U`. Links into `~/Library/Application Support/iTerm2/DynamicProfiles/`; every setting not listed inherits from the box's default profile. Set it as default once: Settings > Profiles > Fleet > Other Actions > Set as Default. iTerm2 reloads the folder on change; after editing the file, `touch` the link or restart iTerm2.
- `Brewfile` -- mac only; `brew bundle --file ~/github/dotfiles/Brewfile`. `install.sh` does not run it.
- `scripts/preview-dir-colors.sh` -- prints every `config/dircolors` rule in its own color
- `archive/` -- not deployed, historical reference

## Fleet identity and prompt

Each box shows its fleet name in the prompt, in its own color: `m5pro` 212, `m4max` 39, `vinelab` 120, `fedora` 196. The name comes from `host.name` in `~/.claude/settings.local.json` (seeded by claude-config's `bootstrap.sh`), because hostnames are DHCP-unreliable on the Macs. Fallback is `$HOST`.

## Git identity notes

- Git reads `~/.config/git/config`, but only when `~/.gitconfig` does not exist. `install.sh` removes the old `~/.gitconfig` link for you. If a box has a real `~/.gitconfig`, the script leaves it and the new config stays inert.
- Work repos are matched by `includeIf "gitdir:..."` blocks in `config/git/config` (posthog, posthog.com, gtm-toolkit, runbooks). Add one block per new work repo dir.
- Verify: `git -C ~/github/posthog config user.email` -> `jake.s@posthog.com`; anywhere else -> gmail.
- GitHub squash-merges attribute commits by the **account's** verified email, independent of this local config. Keep `jake.s@posthog.com` verified at github.com/settings/emails.

## Hammerspoon setup

1. Install: `brew install --cask hammerspoon`
2. Launch once. Grant Accessibility permission: System Settings → Privacy & Security → Accessibility → enable Hammerspoon.
3. `install.sh` links the config on macOS.
4. Menubar icon → Reload Config. "Config loaded" toast confirms.
5. Use `Cmd+Shift+V` to paste clipboard with leading whitespace stripped. `Cmd+V` untouched.
