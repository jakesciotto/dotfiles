# Linux layer: GNU tools are native, no brew.

# Custom colors for file extensions
[ -r ~/.config/dircolors ] && eval "$(dircolors -b ~/.config/dircolors)"
export LS_COLORS
alias ls='ls -a --color=auto'

alias ip='hostname -I'
