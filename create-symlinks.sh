#!/usr/bin/env bash

set -e

CWD=${CWD:-$(pwd)}
links=("profile" "bash_profile" "bashrc" "zshrc" "aliases.sh" "tmux.conf" "vim" "commonrc.sh")

cd $HOME

# Create symlinks
for link in ${links[@]}
do
    ln -sf "$CWD/$link" ".$link"
done

cd $CWD
