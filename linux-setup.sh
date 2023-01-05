#!/bin/bash

set -e

echo "-> Setting up linux!"

CWD=$(pwd)

# install apt dependencies
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y tmux vim curl wget tree git dirmngr gpg gawk stow \
                        autoconf bison patch build-essential rustc libssl-dev \
                        libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev \
                        libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev

# install snap -> starship
if test ! $(which starship) ; then
    echo "-> Installing starship"
    sudo snap install starship
else
    echo "-> Update starship"
    sudo snap refresh starship
fi

# install asdf
if [ ! -d "$HOME/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
fi
# initialize asdf
. $HOME/.asdf/asdf.sh


    #brew install coreutils  \
     #             fd fzf \
       #          gnupg gnupg2 \
        #         cmake

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
fi
if asdf plugin list | grep -q 'ruby'; then
    echo "-> Update Ruby plugin"
    asdf plugin update ruby
else
    echo "-> Add Ruby plugin"
    asdf plugin add ruby
fi

echo "-> Setup default versions for ASDF"
stow -t $HOME asdf
asdf install

# create backup dir for dot files
mkdir -p "$HOME/.dot-files.bkp"

# Setup starship
echo "-> Setup starship"
stow -t $HOME starship

# link dot files
echo "-> Setup Profile"
if [ -f "$HOME/.profile" ]; then
    mv "$HOME/.profile" "$HOME/.dot-files.bkp"
fi
stow -t $HOME profile

echo "-> Setup Bash"
if [ -f "$HOME/.bash_profile" ]; then
    mv "$HOME/.bash_profile" "$HOME/.dot-files.bkp"
fi
if [ -f "$HOME/.bashrc" ]; then
    mv "$HOME/.bashrc" "$HOME/.dot-files.bkp"
fi
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
