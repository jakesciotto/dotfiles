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

# PostHog Desktop bundles its own Claude CLI and sets CLAUDE_CONFIG_DIR to its own
# data dir, so it keeps a SECOND plugin install that `claude` on PATH never touches.
# `pcode` runs that CLI against that config dir: `pcode plugin list`, `pcode plugin update <p>`.
pcode() {
  local app=/Applications/PostHog.app/Contents/Resources/app.asar.unpacked/.vite/build/claude-cli/claude
  [ -x "$app" ] || { print -u2 "pcode: PostHog Desktop CLI not found at $app"; return 1; }
  CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/@posthog/posthog-code/claude" "$app" "$@"
}

# Update a plugin in BOTH Claude homes. A hogpilot release needs both, or Desktop
# keeps running the frozen older copy. Defaults to hogpilot.
plugin-sync() {
  local p="${1:-hogpilot@hogpilot}"
  print "terminal:"; claude plugin update "$p"
  print "desktop:";  pcode  plugin update "$p"
}

alias docs='cd ~/Documents/customers'
alias trash='trash -v'
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'
alias ip='ipconfig getifaddr en0'
