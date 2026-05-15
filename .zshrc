# Default editor
export EDITOR='vim'

# Evaluations
eval $(/opt/homebrew/bin/brew shellenv)

# Prompt
export PROMPT='%* [%n %F{190}%B%c%b%f]$ '

# Custom colors for file extensions
eval $(gdircolors -b ~/.dir_colors)
export LS_COLORS

# Path
export PNPM_HOME="$HOME/Library/pnpm"
typeset -U path
path=(
  /opt/homebrew/opt/openjdk@17/bin
  $HOME/.local/bin
  $PNPM_HOME
  $path
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
)

# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias docs='cd /Users/jakesciotto/Documents/customers'
alias ls='gls --color=auto'
alias ll='ls -al'
alias path='echo -e ${PATH//:/\\n}'
alias trash='trash -v'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias refresh='source ~/.zshrc'
alias tokens='npx ccusage@latest blocks --live'

# Networking
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'
alias ip='ipconfig getifaddr en0'

# Copy and paste

autoload -Uz bracketed-paste-magic                            
zle -N bracketed-paste bracketed-paste-magic                       

_paste_strip_ws() {                                           
    PASTED=${PASTED//$'\r'/$'\n'}                               
    PASTED=$(print -r -- "$PASTED" | sed -E 's/^[[:space:]]+//')
  } 

zstyle :bracketed-paste-magic paste-init _paste_strip_ws      
# Initialize direnv - added by PostHog's Flox activation hook (../posthog/.flox/env/manifest.toml)
eval "$(direnv hook zsh)"
export COMPOSE_HTTP_TIMEOUT=300
