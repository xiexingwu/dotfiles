# antidote
source ${HOMEBREW_PREFIX}/opt/antidote/share/antidote/antidote.zsh
antidote load ${ZDIR}/.zsh_plugins.txt

# kitty - https://sw.kovidgoyal.net/kitty/conf/#shortcut-kitty.Reset-the-terminal
ctrl_l() {
    builtin print -rn -- $'\r\e[0J\e[H\e[22J' >"$TTY"
    builtin zle .reset-prompt
    builtin zle -R
}
zle -N ctrl_l
bindkey '^l' ctrl_l

# zsh
disable -p '#' # disable # for pattern matching
source $ZDIR/oh-my-zsh.sh

source /opt/homebrew/etc/profile.d/z.sh # zoxide

# brew autocomplete for zsh
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# google-cloud
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# pnpm
export PNPM_HOME="/Users/xiexingwu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# #nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
#
# # chromium depo tools
# export PATH="$PATH:$HOME/src/depot_tools"

# Add .NET Core SDK tools
export PATH="$PATH:/Users/xiexingwu/.dotnet/tools"

# zk
export ZK_NOTEBOOK_DIR=$HOME/zk-notes

## Python venv
# usage
# $ mkvenv myvirtualenv # creates venv under ~/.virtualenvs/
# $ venv myvirtualenv   # activates venv
# $ deactivate          # deactivates venv
# $ rmvenv myvirtualenv # removes venv

export VENV_HOME="$HOME/.virtualenvs"
[[ -d $VENV_HOME ]] || mkdir $VENV_HOME

lsvenv() {
  ls -1 $VENV_HOME
}

venv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      source "$VENV_HOME/$1/bin/activate"
  fi
}

mkvenv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      python3 -m venv $VENV_HOME/$1
  fi
}

rmvenv() {
  if [ $# -eq 0 ]
    then
      echo "Please provide venv name"
    else
      rm -r $VENV_HOME/$1
  fi
}


# starship
eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
