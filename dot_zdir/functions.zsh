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
function la(){
    l -a $*
}
function ld(){
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
