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
function gw(){
    git worktree $*
}

# neovim
alias v="nvim"
function s(){
  mkdir -p $HOME/scratch
  _SCRATCH=scratch-$(date "+%Y-%m-%d-%H-%M-%S").md
  touch $HOME/scratch/$_SCRATCH
  nvim "+cd $HOME/scratch" $HOME/scratch/$_SCRATCH
}
