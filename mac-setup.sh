#!/bin/bash

set -e

# setting up mac
echo "-> Hello me! congrats on throwing out the junk!"
# hopefully I will run this only when I buy a new mac

# install brew or update brew
if test ! $(which brew) ; then
	echo "-> Installing brew"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	echo "-> Found brew, updating"
	brew update
fi

# install git
brew install git --with-brewed-openssl --with-brewed-curl --with-blk-sha1 --with-brewed-svn

# install bash
brew install bash

# install vim
brew install vim --override-system-vi

# install tmux
brew install tmux

# initialize git
ID_RSA="~/.ssh/id_rsa"
EMAIL=""

if [! -d "$ID_RSA"]; then
	echo "Your Email Sir!"
	read $EMAIL
	ssh-keygen -t rsa -b 4096 -C "$EMAIL"
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_rsa
	echo "Please add public key to github Sir!"
fi

# install gvm (golang)
GVM_DIR="~/.gvm"
if [ ! -d "$GVM_DIR" ]; then
	echo "-> Installing gvm"
	bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
fi
if test ! $(which gvm) ; then
	# i want to use it now!!!
	source /Users/suyash/.gvm/scripts/gvm
else
	echo "-> Found gvm"
fi

gvm install go1.4 --binary
# i want to use golang now!!!
export GOROOT=/Users/suyash/.gvm/gos/go1.4

# install golang 1.6
gvm install go1.6 --with-protobuf --with-build-tools

# link bash files
ln -sf .bash_profile ../.bash_profile
ln -sf .bashrc ../.bashrc
