# ---------------------------
# .zshrc
# 
# 1. Prompt
# 2. Colorization of the terminal
# 3. Aliases
# ---------------------------

# Prompt
PROMPT='%T [%n %F{190}%.%f] '

# Colorization of output in terminal
eval $(gdircolors -b ~/.dir_colors)
export LS_COLORS

# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ls='gls --color=auto'
alias ll='ls -al'
alias path='echo -e ${PATH//:/\\n}'
alias trash='trash -v'
alias mv='mv -iv'
alias mkdir='mkdir -pv'

