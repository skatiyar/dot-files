# Load aliases
source $HOME/.aliases.sh

export LC_ALL=en_US.UTF-8

# Add sbin to path
export PATH="/usr/local/sbin:$PATH"

# fix for tmux error
export EVENT_NOKQUEUE=1

# Installation of nvm via homebrew is not supported
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Setup Go
export GOPATH=~/Work/golang
export PATH=$GOPATH/bin:$PATH
export GO111MODULE=auto

# Setup rusy
source ~/.cargo/env
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# Setup fzf for vim
export FZF_DEFAULT_COMMAND='ag --hidden'
