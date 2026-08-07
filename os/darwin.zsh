# macOS layer: brew, GNU coreutils (g-prefixed), mac-only tools.

eval $(/opt/homebrew/bin/brew shellenv)

# Custom colors for file extensions
eval $(gdircolors -b ~/.dir_colors)
export LS_COLORS
alias ls='gls -a --color=auto'

export PNPM_HOME="$HOME/Library/pnpm"
typeset -U path
path=(
  /opt/homebrew/opt/openjdk@17/bin
  $PNPM_HOME
  $path
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
)

alias docs='cd ~/Documents/customers'
alias trash='trash -v'
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'
alias ip='ipconfig getifaddr en0'
