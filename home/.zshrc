export EDITOR=nvim
# antidote
source ${HOMEBREW_PREFIX}/opt/antidote/share/antidote/antidote.zsh
antidote load ${ZDIR}/.zsh_plugins.txt

# zoxide
eval "$(zoxide init zsh)"
# source /opt/homebrew/etc/profile.d/z.sh # zoxide

# zsh
disable -p '#' # disable # for pattern matching
source $ZDIR/oh-my-zsh.sh

# pnpm
export PNPM_HOME="/Users/xiexingwu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# zk
export ZK_NOTEBOOK_DIR=$HOME/zk-notes

# starship
eval "$(starship init zsh)"

# >>> oh-my-opencode-slim background subagents >>>
export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=true
export OPENCODE_ENABLE_EXA=1
# <<< oh-my-opencode-slim background subagents <<<

# opencode
export PATH=/Users/xiexingwu/.opencode/bin:$PATH
