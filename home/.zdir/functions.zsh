function l(){
    eza -l --group-directories-first -h --git $*
}
alias ll=l -a

# git
function git-prune-branches(){
    git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}
alias g="git"
alias gw="git worktree"

alias lg="lazygit"
# neovim
alias v="nvim"
# zellij: bare `zj` attaches to (or creates) a session named after the project; `zj <args>` passes through
function zj () {
  if [ $# -gt 0 ]; then
    zellij "$@"
    return
  fi
  if [ -n "$ZELLIJ" ]; then
    echo "already in zellij session '$ZELLIJ_SESSION_NAME'" >&2
    return 1
  fi
  local root=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
  zellij attach -c "${root:t}"
}
# zk
alias s="zk edit -t scratch -m scratch"

# AI
alias oc="opencode --auto"
alias claudej="CLAUDE_CONFIG_DIR=$HOME/.claude-jessie claude"
