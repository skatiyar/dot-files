# Load configs common between shells.
source $HOME/.commonrc.sh

# Android sdk
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
export ANDROID_HOME=/usr/local/share/android-sdk

# tensorflow
# Change to "gpu" for GPU support
export TF_TYPE=cpu
# export LIBRARY_PATH=$LIBRARY_PATH:~/Work/tfplay/lib
# export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:~/Work/tfplay/lib

function parse_git_dirty {
    [[ $(git status --porcelain 2> /dev/null | tail -n1) != "" ]] && echo " (~)"
}
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1)$(parse_git_dirty)/"
}

export PS1="\u \[\033[32m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

# Auto-attach or start tmux at login
if [[ "$TERM" != "screen" ]] && [[ "$SSH_CONNECTION" == "" ]]; then
    if ! [ -n "$TMUX" ]; then
        if ! tmux info &> /dev/null; then
            ta 27AE60 || tn 27AE60
        fi
    fi
fi

# fzf via Homebrew
if [ -e /usr/local/opt/fzf/shell/completion.bash ]; then
    source /usr/local/opt/fzf/shell/key-bindings.bash
    source /usr/local/opt/fzf/shell/completion.bash
fi

# Setup autocomplete for cd & vim
# fzf auto completion
if ! declare -f _fzf_compgen_file_path > /dev/null; then
    _fzf_compgen_file_path() {
        command fd --type f --hidden --exclude .git --no-ignore-vcs "$1" 2> /dev/null | sed 's@^\./@@'
    }
fi
if ! declare -f _fzf_compgen_dir_path > /dev/null; then
    _fzf_compgen_dir_path() {
        command fd --type d --hidden --exclude .git --no-ignore-vcs "$1" 2> /dev/null | sed 's@^\./@@'
    }
fi

_fzf_complete_cd_notrigger() {
    FZF_COMPLETION_TRIGGER='' __fzf_generic_path_completion _fzf_compgen_dir_path "--height=12" "/" "$@"
}

_fzf_complete_vim_notrigger() {
    FZF_COMPLETION_TRIGGER='' __fzf_generic_path_completion _fzf_compgen_file_path "-m --height=12" "" "$@"
}
complete -o bashdefault -o default -F _fzf_complete_cd_notrigger cd
complete -o bashdefault -o default -F _fzf_complete_vim_notrigger vim
