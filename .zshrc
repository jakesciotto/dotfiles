# ----------------------------------------
# .zshrc
# 
# Standard commands and settings across machines
# ----------------------------------------


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

# Binds correctly the option+left arrow and option+right arrow key combindations
# that the shell is overwriting 
bindkey "^[f" forward-word
bindkey "^[b" backward-word

###### Functions #######

# 1. Copy and paste 
autoload -Uz bracketed-paste-magic                            
zle -N bracketed-paste bracketed-paste-magic                       

_paste_strip_ws() {                                           
    PASTED=${PASTED//$'\r'/$'\n'}                               
    PASTED=$(print -r -- "$PASTED" | sed -E 's/^[[:space:]]+//')
  } 

zstyle :bracketed-paste-magic paste-init _paste_strip_ws   

# 2. Github commit to current branch

gacp() {
    if [ $# -lt 2 ]; then
      echo "usage: gacp <branch> <message>"
      return 1
    fi
    local branch="$1"
    shift
    local message="$*"
    git add -A && git commit -m "$message" && git push origin "$branch"
  }


# 3. Github merge function

gmerge() {
    if [ $# -lt 1 ]; then
      echo "usage: gmerge <message>"
      return 1
    fi
    local message="$*"
    local source target
    source=$(git symbolic-ref --short HEAD) || return 1

    if [ "$source" = "main" ]; then
      echo "already on main — nothing to merge upward"
      return 1
    elif [ "$source" = "staging" ]; then
      target="main"
    else
      target="staging"
    fi

    echo "merging $source -> $target"
    git checkout "$target" \
      && git pull origin "$target" \
      && git merge --no-ff "$source" -m "$message" \
      && git push origin "$target" \
      && git checkout "$source"
  }