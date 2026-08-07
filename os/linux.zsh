# Linux layer: GNU tools are native, no brew.

# Custom colors for file extensions
eval "$(dircolors -b ~/.dir_colors)"
export LS_COLORS
alias ls='ls -a --color=auto'

alias ip='hostname -I'
