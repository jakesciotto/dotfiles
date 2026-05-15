# dotfiles

## Managed

- `.zshrc` -- shell config, aliases, gdircolors integration
- `.dir_colors` -- terminal colorization rules (256-color)
- `.bash_profile` -- legacy bash config
- `.vimrc` -- yanked a good .vimrc from online
- `.hammerspoon/init.lua` -- Hammerspoon config; binds `Cmd+Shift+V` to clean-paste (strips leading whitespace from clipboard before pasting)

## Layout

```
.zshrc                   -> ~/.zshrc
.dir_colors              -> ~/.dir_colors
.bash_profile            -> ~/.bash_profile
.hammerspoon/init.lua    -> ~/.hammerspoon/init.lua
archive/                 -> not deployed, historical reference
```

## Hammerspoon setup

1. Install: `brew install --cask hammerspoon`
2. Launch once. Grant Accessibility permission: System Settings → Privacy & Security → Accessibility → enable Hammerspoon.
3. Symlink config:
   ```
   mkdir -p ~/.hammerspoon
   ln -s ~/github/dotfiles/.hammerspoon/init.lua ~/.hammerspoon/init.lua
   ```
4. Menubar icon → Reload Config. "Config loaded" toast confirms.
5. Use `Cmd+Shift+V` to paste clipboard with leading whitespace stripped. `Cmd+V` untouched.
