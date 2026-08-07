##################################################
# .zshrc
#
# Shared core for every box. OS-specific config
# lives in os/darwin.zsh and os/linux.zsh; a box
# adds hosts/<box>.zsh for one-off tweaks.
#
# Table of contents
# ---
# 1. Fleet identity + prompt
# 2. Configuration
# 3. Functions
# 4. OS + host layers
##################################################

DOTFILES="$HOME/github/dotfiles"

# ----------------------------------------
# :: 1. Fleet identity + prompt
# ----------------------------------------

# Box name comes from the Claude telemetry config: hostnames are
# DHCP-unreliable on the Macs.
BOX=$(sed -n 's/.*host\.name=\([^",]*\).*/\1/p' ~/.claude/settings.local.json 2>/dev/null | head -1)
[[ -z $BOX ]] && BOX=${HOST%%.*}

case $BOX in
  m5pro)   BOX_COLOR=212 ;;
  m4max)   BOX_COLOR=39 ;;
  vinelab) BOX_COLOR=120 ;;
  fedora)  BOX_COLOR=196 ;;
  *)       BOX_COLOR=245 ;;
esac

export PROMPT="%* [%F{$BOX_COLOR}${BOX}%f %F{190}%B%c%b%f]$ "

# iTerm2 status bar: publish this box's fleet name as \(user.box).
if [[ -n $ITERM_SESSION_ID ]]; then
  printf '\e]1337;SetUserVar=box=%s\a' "$(printf %s "$BOX" | base64)"
fi

# ----------------------------------------
# :: 2. Configuration
# ----------------------------------------

# Path
typeset -U path
path=(
  $HOME/bin
  $HOME/.local/bin
  $path
)

# Default editor
export EDITOR='vim'

# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -al'
alias path='echo -e ${PATH//:/\\n}'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias refresh='source ~/.zshrc'
alias tokens='npx ccusage@latest blocks --live'
alias c='claude'
alias cc='cd ~/github/claude-config'

# Binds correctly the option+left arrow and option+right arrow key combinations
# that the shell is overwriting
bindkey "^[f" forward-word
bindkey "^[b" backward-word

# ----------------------------------------
# :: 3. Functions
# ----------------------------------------

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
    if [ $# -lt 1 ]; then
      echo "usage: gacp [branch] <message>"
      return 1
    fi

    local branch
    # If the first arg matches a local branch name, treat it as the target
    if [ $# -ge 2 ] && git show-ref --verify --quiet "refs/heads/$1"; then
      branch="$1"
      shift
    else
      # Detect the default branch: prefer origin/HEAD, fall back to main/master
      branch=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
      if [ -z "$branch" ]; then
        for candidate in main master; do
          if git show-ref --verify --quiet "refs/heads/$candidate"; then
            branch="$candidate"
            break
          fi
        done
      fi
      if [ -z "$branch" ]; then
        echo "could not detect default branch; pass it explicitly"
        return 1
      fi
    fi

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
      echo "already on main - nothing to merge upward"
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

# ----------------------------------------
# :: 4. OS + host layers
# ----------------------------------------

case "$(uname -s)" in
  Darwin) source "$DOTFILES/os/darwin.zsh" ;;
  Linux)  source "$DOTFILES/os/linux.zsh" ;;
esac

[[ -f "$DOTFILES/hosts/$BOX.zsh" ]] && source "$DOTFILES/hosts/$BOX.zsh"
