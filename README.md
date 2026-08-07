# dotfiles

Shared shell and git config for the four-box fleet: `m5pro` and `m4max` (macOS), `vinelab` and `fedora` (Linux). All zsh.

`install.sh` symlinks everything into `$HOME` (idempotent; a real file at a target is backed up to `<name>.pre-dotfiles`).

```
git clone https://github.com/jakesciotto/dotfiles ~/github/dotfiles
~/github/dotfiles/install.sh
```

## Structure

- `.zshrc` -- shared core: fleet identity + prompt, aliases, functions. Sources the OS layer, then an optional host layer.
- `os/darwin.zsh`, `os/linux.zsh` -- OS-specific: brew and g-prefixed coreutils vs native GNU tools.
- `hosts/<box>.zsh` -- optional per-box one-offs, sourced last. Intentional divergence goes here, tracked, instead of hand-edits on the box.
- `.dir_colors` -- terminal colorization rules (256-color), shared by both `gdircolors` (mac) and `dircolors` (linux).
- `.gitconfig` -- identity + per-repo PostHog includes. `jake.s@posthog.com` is the default on every box.
- `.gitconfig-posthog` -- work identity include for PostHog repo dirs.
- `.gitconfig-signing` -- SSH commit signing; loaded only on the Macs via `includeIf "gitdir:/Users/"`, since only they hold the key. Keeps `commit.gpgsign=true` from breaking commits on the Linux boxes.
- `~/.gitconfig-local` -- machine-local include, never tracked: credential helpers (`gh auth git-credential` paths differ per box) and any box-specific overrides.
- `.vimrc` -- yanked a good .vimrc from online
- `.hammerspoon/init.lua` -- mac only; binds `Cmd+Shift+V` to clean-paste (strips leading whitespace from clipboard before pasting)
- `archive/` -- not deployed, historical reference

## Fleet identity and prompt

Each box shows its fleet name in the prompt, in its own color: `m5pro` 212, `m4max` 39, `vinelab` 120, `fedora` 196. The name comes from `host.name` in `~/.claude/settings.local.json` (seeded by claude-config's `bootstrap.sh`), because hostnames are DHCP-unreliable on the Macs. Fallback is `$HOST`.

## Git identity notes

- PostHog repos are matched by `includeIf "gitdir:..."` blocks in `.gitconfig`. Add one block per new PostHog repo dir.
- Verify: `git -C ~/github/posthog config user.email` -> `jake.s@posthog.com`.
- GitHub squash-merges attribute commits by the **account's** verified email, independent of this local config. Keep `jake.s@posthog.com` verified at github.com/settings/emails.

## Hammerspoon setup

1. Install: `brew install --cask hammerspoon`
2. Launch once. Grant Accessibility permission: System Settings → Privacy & Security → Accessibility → enable Hammerspoon.
3. `install.sh` links the config on macOS.
4. Menubar icon → Reload Config. "Config loaded" toast confirms.
5. Use `Cmd+Shift+V` to paste clipboard with leading whitespace stripped. `Cmd+V` untouched.
