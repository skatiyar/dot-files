#!/usr/bin/env bash

set -e

cwd=$(pwd)
links=("profile" "bash_profile" "bashrc" "zshrc" "aliases.sh" "tmux.conf" "vim")

cd $HOME

# Create symlinks
for link in ${links[@]}
do
    ln -sf "$cwd/$link" ".$link"
done

cd $pwd
