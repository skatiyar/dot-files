# Add sbin to path
export PATH="/usr/local/sbin:$PATH"

# Add flutter to path
export PATH="$PATH:$HOME/.flutter-sdk/bin"

# Setup Go
export GOPATH=~/Work/golang
export PATH=$GOPATH/bin:$PATH
export GO111MODULE=auto

# Setup rusy
source ~/.cargo/env
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# Setup fzf for vim
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
