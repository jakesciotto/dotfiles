# Evaluations
eval $(/opt/homebrew/bin/brew shellenv)

# Prompt
export PROMPT='%* [%n %F{190}%B%c%b%f]$ '

# Custom colors for file extensions
eval $(gdircolors -b ~/.dir_colors)
export LS_COLORS

# Path variables
export PATH=$PATH:"/Applications/Sublime Text.app/Contents/SharedSupport/bin"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

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
alias vinelab-status='./.server/vinelab-status'
alias vlabhome='ssh jake@192.168.5.48'
alias vlabaway='ssh jake@100.70.246.68'

# Networking
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'
alias ip='ipconfig getifaddr en0'
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/jakesciotto/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
