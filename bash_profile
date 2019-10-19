#!/usr/bin/env bash

# Don't check mail when opening terminal.
unset MAILCHECK

# Load Bashrc file
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
