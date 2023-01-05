export LANG=en_US.utf-8
export LC_ALL=en_US.UTF-8

# Setup ASDF for language version management
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# Don't check mail when opening terminal.
unset MAILCHECK

# Start starship
eval "$(starship init bash)"

# Load aliases
if [ -f ~/.aliases ]; then
    . $HOME/.aliases
fi

# fix for tmux error
export EVENT_NOKQUEUE=1

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Android sdk
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
export ANDROID_HOME=/usr/local/share/android-sdk

# tensorflow
# Change to "gpu" for GPU support
export TF_TYPE=cpu
# export LIBRARY_PATH=$LIBRARY_PATH:~/Work/tfplay/lib
# export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:~/Work/tfplay/lib

# fzf via Homebrew
# if [ -e /usr/local/opt/fzf/shell/completion.bash ]; then
#     source /usr/local/opt/fzf/shell/key-bindings.bash
#     source /usr/local/opt/fzf/shell/completion.bash
# fi

# Setup fzf for vim
# export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

# Setup autocomplete for cd & vim
# fzf auto completion
# if ! declare -f _fzf_compgen_file_path > /dev/null; then
#     _fzf_compgen_file_path() {
#         command fd --type f --hidden --exclude .git --no-ignore-vcs . "$1" 2> /dev/null | sed 's@^\./@@'
#     }
# fi
# if ! declare -f _fzf_compgen_dir_path > /dev/null; then
#     _fzf_compgen_dir_path() {
#         command fd --type d --hidden --exclude .git --no-ignore-vcs . "$1" 2> /dev/null | sed 's@^\./@@'
#     }
# fi

# _fzf_complete_cd_notrigger() {
#     FZF_COMPLETION_TRIGGER='' __fzf_generic_path_completion _fzf_compgen_dir_path "--height=12" "/" "$@"
# }

# _fzf_complete_vim_notrigger() {
#     FZF_COMPLETION_TRIGGER='' __fzf_generic_path_completion _fzf_compgen_file_path "-m --height=12" "" "$@"
# }
# complete -o bashdefault -o default -F _fzf_complete_cd_notrigger cd
# complete -o bashdefault -o default -F _fzf_complete_vim_notrigger vim
