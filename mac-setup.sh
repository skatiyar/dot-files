#!/bin/sh

set -e

# setting up mac
echo "-> Hello me! congrats on throwing out the junk!"
# hopefully I will run this only when I buy a new mac

CWD=$(pwd)

# install brew or update brew
if test ! $(which brew) ; then
	echo "-> Installing brew"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Setup basic packages like git, bash, vim, tmux etc.
    brew install git bash vim tmux fd fzf reattach-to-user-namespace tree wget the_silver_searcher
else
	echo "-> Found brew, updating."
	brew upgrade
fi

# initialize git
echo "-> Setting up SSH."
ID_RSA="$HOME/.ssh/id_rsa"
EMAIL=""

if [ ! -f "$ID_RSA" ]; then
	echo "-> SSH Email."
	read $EMAIL
	ssh-keygen -t rsa -b 4096 -C "$EMAIL"
	eval "$(ssh-agent -s)"
	ssh-add $HOME/.ssh/id_rsa
	echo "-> SSH setup complete, add public key."
else
    echo "-> SSH already setup."
fi

# install nvm
echo "-> Setting up NodeJS using NVM."
NVM_DIR=$HOME/.nvm
if [ ! -f "$NVM_DIR/nvm.sh" ]  ; then
    git clone https://github.com/nvm-sh/nvm.git $NVM_DIR
    cd $NVM_DIR
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    cd $CWD
    source $NVM_DIR/nvm.sh
    echo "-> Installing latest node LTS."
    nvm install --lts
    nvm alias default node
else
    echo "-> NVM already setup, upgrading."
    cd $NVM_DIR
    git fetch --tags origin
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    cd $CWD
    source $NVM_DIR/nvm.sh
fi
echo "-> NodeJS version: $(node --version)"


# install gvm (golang)
# GVM_DIR="~/.gvm"
# if [ ! -d "$GVM_DIR" ]; then
#	echo "-> Installing gvm"
#	bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
#fi
#if test ! $(which gvm) ; then
	# i want to use it now!!!
#	source /Users/suyash/.gvm/scripts/gvm
#else
#	echo "-> Found gvm"
#fi

# gvm install go1.4 --binary
# i want to use golang now!!!
# export GOROOT=/Users/suyash/.gvm/gos/go1.4

# install golang 1.6
# gvm install go1.6 --with-protobuf --with-build-tools

# link bash files
echo "-> Setting up symlinks."
source ./create-symlinks.sh

# Setup vim
echo "-> Setting up VIM."
vim +PlugInstall +qall
