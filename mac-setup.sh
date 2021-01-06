#!/bin/sh

set -e

echo "-> Setting up mac!"

CWD=$(pwd)

# install brew or update brew
if test ! $(which brew) ; then
	echo "-> Installing brew"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Setup basic packages like git, bash, vim, tmux etc.
    brew install git bash vim coreutils curl \
                 tmux fd fzf tree wget \
                 reattach-to-user-namespace \
                 stow starship asdf gnupg gnupg2

    # Setup Homebrew taps
    echo "-> Tap brew service"
    brew tap homebrew/services
    echo "-> Tap brew fonts"
    brew tap homebrew/cask-fonts
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

# Setup ASDF
echo "-> Setup ASDF"
if asdf plugin list | grep -q 'golang'; then
    echo "-> Update Golang plugin"
    asdf plugin update golang
else
    echo "-> Add Golang plugin"
    asdf plugin add golang
fi
if asdf plugin list | grep -q 'nodejs'; then
    echo "-> Update NodeJS plugin"
    asdf plugin update nodejs
else
    echo "-> Add NodeJS plugin"
    asdf plugin add nodejs
    # Import the Node.js release team's OpenPGP keys
    bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
fi

echo "-> Setup default versions for ASDF"
stow -t $HOME asdf
asdf install

# Setup starship
echo "-> Setup starship"
stow -t $HOME starship

# link dot files
echo "-> Setup Profile"
stow -t $HOME profile

echo "-> Setup ZSH"
stow -t $HOME zsh

echo "-> Setup Bash"
stow -t $HOME bash

echo "-> Setup Aliases"
stow -t $HOME aliases

echo "-> Setup Tmux"
export TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins/
stow -t $HOME tmux
if test ! -d $HOME/.tmux/plugins/tpm ; then
    echo "-> Install tmux plugins"
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    source $HOME/.tmux/plugins/tpm/bin/install_plugins
else
    echo "-> Updating tmux plugins"
    source $HOME/.tmux/plugins/tpm/bin/update_plugins all
fi

#links=("vim" "commonrc.sh")
# Setup vim
# echo "-> Setting up VIM."
# vim +PlugInstall +qall
