# CHANGELOG.md

## Change Categories

Use these standard categories for each version entry:

- **Added** — New features or capabilities
- **Changed** — Changes to existing functionality
- **Deprecated** — Soon-to-be removed features
- **Removed** — Removed features
- **Fixed** — Bug fixes
- **Security** — Security vulnerability fixes

---

## Template Entry

Copy and customize this template for new releases:

```
## [X.Y.Z] - YYYY-MM-DD

### Added

- New feature 1

### Changed

- Updated behavior of existing feature

### Fixed

- Bug fix 1

### Security

- Security fix 1
```

---

## [Unreleased]

### Added

- `install.sh`: idempotent symlink installer with real-file backup (`<name>.pre-dotfiles`)
- `os/darwin.zsh` and `os/linux.zsh`: OS layers sourced by the shared `.zshrc` core
- `hosts/<box>.zsh` convention for tracked per-box tweaks
- `.gitconfig-signing`: SSH signing config, loaded only on Macs via `includeIf "gitdir:/Users/"`
- `.gitconfig` and `.gitconfig-posthog` now tracked
- `~/.gitconfig-local` include: machine-local credential helpers and overrides, never tracked

### Changed

- `.zshrc` split into shared core + OS layer; prompt shows the fleet box name in a per-box color (m5pro/m4max 212, vinelab 120, fedora 196)
- `.gitconfig` default identity comment corrected: jake.s@posthog.com is the default everywhere, not gmail

---

**Note:** Maintain this changelog by adding entries under `[Unreleased]` during development, then moving them to a versioned section at release time.
