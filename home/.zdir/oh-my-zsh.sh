# my lean version of oh-my-zsh entry script


# Set ZSH_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
if [[ -z "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="$ZDIR/cache"
fi

# Make sure $ZSH_CACHE_DIR is writable, otherwise use a directory in $HOME
if [[ ! -w "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zdir"
fi

# Create cache and completions dir and add to $fpath
mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# add a function path
fpath=("$ZDIR/functions" "$ZDIR/completions" $fpath)

# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit zrecompile

# Figure out the SHORT hostname
if [[ "$OSTYPE" = darwin* ]]; then
  # macOS's $HOST changes with dhcp, etc. Use ComputerName if possible.
  SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST="${HOST/.*/}"
else
  SHORT_HOST="${HOST/.*/}"
fi

# Save the location of the current completion dump file.
if [[ -z "$ZSH_COMPDUMP" ]]; then
  ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
fi

# If the user wants it, load from all found directories
compinit -u -d "$ZSH_COMPDUMP"

# zcompile the completion dump file if the .zwc is older or missing.
zrecompile -q -p "$ZSH_COMPDUMP"

# load from .zdir all ending in .zsh
for config_file ("$ZDIR"/*.zsh(N)); do
  source "$config_file"
done
unset config_file

# set completion colors to be the same as `ls`, after theme has been loaded
[[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

