# dotfiles

Managed with [chezmoi](https://chezmoi.io). Files use `dot_` prefix convention.

## Managed

- `.zshrc` -- shell config, aliases, gdircolors integration
- `.dir_colors` -- terminal colorization rules (256-color)
- `.bash_profile` -- legacy bash config
- `.claude/` -- Claude Code settings and project rules

## Layout

```
dot_zshrc           -> ~/.zshrc
dot_dir_colors      -> ~/.dir_colors
dot_bash_profile    -> ~/.bash_profile
dot_claude/         -> ~/.claude/
archive/            -> not deployed, historical reference
```
