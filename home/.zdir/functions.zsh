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
# zellij: sessions are named after the project (git root, else cwd) and only created deliberately.
#   zj new    create the project session, then attach (or switch, from inside zellij)
#   zj        attach/switch to the project session, resurrecting it if it was saved
#   zj <args> passes through to zellij
function zj () {
  if [[ $# -gt 0 && $1 != new ]]; then
    zellij "$@"
    return
  fi
  local root=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
  local name=${root:t}
  local state=$(zellij ls -n 2>/dev/null | awk -v n="$name" '$1 == n { print (/EXITED/ ? "exited" : "live") }')
  if [[ -z $state && $1 != new ]]; then
    echo "no session '$name'; create it with: zj new" >&2
    return 1
  fi
  if [[ -z $ZELLIJ ]]; then
    (cd "$root" && zellij attach -c "$name")
    return
  fi
  if [[ $name == $ZELLIJ_SESSION_NAME ]]; then
    echo "already in zellij session '$name'" >&2
    return 1
  fi
  # switch-session creates missing sessions but won't resurrect exited ones
  [[ $state == exited ]] && zellij attach -b "$name"
  zellij action switch-session "$name" --cwd "$root"
}
# zk
alias s="zk edit -t scratch -m scratch"

# AI
alias oc="opencode --auto"
alias claudej="CLAUDE_CONFIG_DIR=$HOME/.claude-jessie claude"
