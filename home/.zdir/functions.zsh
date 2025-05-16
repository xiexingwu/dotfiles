# List directory contents
function ls(){
    if (command eza &> /dev/null); then
        eza $*
    else
        ls
    fi
}
function l(){
    ls -l --group-directories-first -h --git $*
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

# dush <depth>
function dush(){
    depth=${1:-0}
    if (command eza &> /dev/null); then
        eza -l --total-size -D -T -L $depth
    else
        du -sh $depth
    fi
}

# git
function git-prune-branches(){
    git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}
alias g="git"
alias gw="git worktree"
# function gw(){
#     git worktree $*
# }

# neovim
alias v="nvim"
function s(){
  mkdir -p $HOME/scratch
  # _SCRATCH=scratch-$(date "+%Y-%m-%d-%H-%M-%S").md
  _SCRATCH=scratch-$(date "+%Y-%m-%d").md
  touch $HOME/scratch/$_SCRATCH
  nvim "+cd $HOME/scratch" $HOME/scratch/$_SCRATCH
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
