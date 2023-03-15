#!/bin/bash

# To setup automatically use: bash <(wget -qO- https://raw.githubusercontent.com/skatiyar/dot-files/master/ubuntu-setup.sh)

set -e

echo "-> Setting up linux!"

# install apt dependencies
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y unzip tmux vim curl wget tree git dirmngr gpg gawk stow \
                        autoconf bison patch build-essential libssl-dev \
                        libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev \
                        libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev

# Download & setup repo
# create backup dir for dot files
BACKUP_DIR="$HOME/.dot-files-backup"
CUR_BACKUP_DIR="$BACKUP_DIR/$(date -d "today" +"%Y%m%d%H%M")"

if [ ! -d "$CUR_BACKUP_DIR"  ]; then
    mkdir -p "$CUR_BACKUP_DIR"
    wget -O dot-files.zip https://github.com/skatiyar/dot-files/archive/refs/heads/master.zip
    unzip dot-files.zip && rm dot-files.zip
    cd dot-files
fi
    
CWD=$(pwd)

# install snap -> starship
if test ! $(which starship) ; then
    echo "-> Installing starship"
    sudo snap install starship --edge
else
    echo "-> Update starship"
    sudo snap refresh starship
fi

# install asdf
if [ ! -d "$HOME/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.2
fi
# initialize asdf
source $HOME/.asdf/asdf.sh

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
if asdf plugin list | grep -q 'rust'; then
    echo "-> Update Rust plugin"
    asdf plugin update rust
else
    echo "-> Add Rust plugin"
    asdf plugin-add rust https://github.com/asdf-community/asdf-rust.git
fi

echo "-> Setup default versions for ASDF"
if [ -f "$HOME/.tool-versions" ]; then
   mv "$HOME/.tool-versions" "$CUR_BACKUP_DIR"
fi
stow -t $HOME asdf
asdf install

# Setup starship
echo "-> Setup starship"
if [ -f "$HOME/.config" ]; then
   mv "$HOME/.config" "$CUR_BACKUP_DIR"
fi
stow -t $HOME starship

# link dot files
echo "-> Setup Profile"
if [ -f "$HOME/.profile" ]; then
    mv "$HOME/.profile" "$CUR_BACKUP_DIR"
fi
stow -t $HOME profile

echo "-> Setup Bash"
if [ -f "$HOME/.bash_profile" ]; then
    mv "$HOME/.bash_profile" "$CUR_BACKUP_DIR"
fi
if [ -f "$HOME/.bashrc" ]; then
    mv "$HOME/.bashrc" "$CUR_BACKUP_DIR"
fi
stow -t $HOME bash

echo "-> Setup Aliases"
if [ -f "$HOME/.aliases" ]; then
    mv "$HOME/.aliases" "$CUR_BACKUP_DIR"
fi
stow -t $HOME aliases

echo "-> Setup Tmux"
export TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins/
if [ -f "$HOME/.tmux.conf" ]; then
    mv "$HOME/.tmux.conf" "$CUR_BACKUP_DIR"
fi
if test ! -d $HOME/.tmux/plugins/tpm ; then
    echo "-> Install tmux plugins"
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    source $HOME/.tmux/plugins/tpm/bin/install_plugins
else
    echo "-> Updating tmux plugins"
    source $HOME/.tmux/plugins/tpm/bin/update_plugins all
fi
stow -t $HOME tmux

