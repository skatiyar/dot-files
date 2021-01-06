export LC_ALL=en_US.UTF-8

# Setup ASDF for language version management
. /usr/local/opt/asdf/asdf.sh

# Command history configs
HISTSIZE=1000
SAVEHIST=1000

eval "$(starship init zsh)"

# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Load aliases
if [ -f ~/.aliases ]; then
    . $HOME/.aliases
fi

# fix for tmux error
export EVENT_NOKQUEUE=1

# Setup fzf for vim
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
