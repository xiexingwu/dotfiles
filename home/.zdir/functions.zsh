function l(){
    eza -l --group-directories-first -h --git $*
}
alias ll=l
function la(){
    l -a $*
}
function lD(){
    l -D $*
}
function lf(){
    l -f $*
}

# git
function git-prune-branches(){
    git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}
alias g="git"
alias gw="git worktree"

# yazi
alias y="yazi"
# neovim
alias v="nvim"
function s(){
  mkdir -p $HOME/scratch
  # _SCRATCH=scratch-$(date "+%Y-%m-%d-%H-%M-%S").md
  _SCRATCH=scratch-$(date "+%Y-%m-%d").md
  touch $HOME/scratch/$_SCRATCH
  nvim "+cd $HOME/scratch" $HOME/scratch/$_SCRATCH
}
function todo(){
  touch $HOME/todo.md
  nvim $HOME/todo.md
}

alias ai="aichat"

# wezterm
function wez_focus_or_spawn_workspace() {
  readonly workspace=${1:?"Specify the workspace name"}
  pid=$(wezterm cli list-clients --format json | jq -c '.[] | select(.workspace == "'$workspace'") | .pid')
  if [[ -n "$pid" ]]; then
    echo "aerospace list-windows --monitor all --pid $pid --format %{window-id} | head -n 1" >> ~/tmp/log
    wid=$(aerospace list-windows --monitor all --pid $pid --format %{window-id} | head -n 1)
    echo aerospace focus --window-id $wid >> ~/tmp/log
    aerospace focus --window-id $wid
  else
    echo wezterm cli spawn --new-window --workspace "$workspace" >> ~/tmp/log
    wezterm cli spawn --new-window --workspace "$workspace"
  fi
}

# zellij
function zr () { zellij run --name "$*" -- zsh -ic "$*";}
function zrf () { zellij run --name "$*" --floating -- zsh -ic "$*";}
function zri () { zellij run --name "$*" --in-place -- zsh -ic "$*";}
function ze () { zellij edit "$*";}
function zef () { zellij edit --floating "$*";}
function zei () { zellij edit --in-place "$*";}
function zpipe () { 
  if [ -z "$1" ]; then
    zellij pipe;
  else 
    zellij pipe -p $1;
  fi
}
