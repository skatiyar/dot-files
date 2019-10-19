#!/bin/bash

set -e

# setting up mac
echo "-> Hello me! congrats on throwing out the junk!"
# hopefully I will run this only when I buy a new mac

# install brew or update brew
if test ! $(which brew) ; then
	echo "-> Installing brew"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Setup basic packages like git, bash, vim & tmux
    # install git
    brew install git --with-brewed-openssl --with-brewed-curl --with-blk-sha1 --with-brewed-svn
    brew install bash
    brew install vim --override-system-vi
    brew install tmux
else
	echo "-> Found brew, updating"
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
	ssh-add ~/.ssh/id_rsa
	echo "-> SSH setup complete, add public key."
else
    echo "-> SSH already setup."
fi

# install nvm


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
