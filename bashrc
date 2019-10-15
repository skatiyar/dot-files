export LC_ALL=C

# Add sbin to path
export PATH="/usr/local/sbin:$PATH"

# fix for tmux error
export EVENT_NOKQUEUE=1

export GOPATH=~/Work/golang
export PATH=$GOPATH/bin:$PATH
export GO111MODULE=auto

# aliases
alias tn="tmux -u new -s"
alias ta="tmux -u attach -t"
alias tl="tmux -u ls"
alias via="vim -c ProseMode"

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

source ~/.cargo/env
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

# Installation of nvm via homebrew is not supported
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Auto-attach or start tmux at login
if [[ "$TERM" != "screen" ]] && [[ "$SSH_CONNECTION" == "" ]]; then
    if ! [ -n "$TMUX" ]; then
        if ! tmux info &> /dev/null; then
            ta 27AE60 || tn 27AE60
        fi
    fi
fi

# Android sdk
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
export ANDROID_HOME=/usr/local/share/android-sdk

# Tab auto completion
# bind 'TAB:menu-complete'

# fzf via Homebrew
if [ -e /usr/local/opt/fzf/shell/completion.bash ]; then
    source /usr/local/opt/fzf/shell/key-bindings.bash
    source /usr/local/opt/fzf/shell/completion.bash
fi

# fzf auto completion
if ! declare -f _fzf_compgen_file_path > /dev/null; then
    _fzf_compgen_file_path() {
        echo "$1"
        command find -L "$1" \
            -maxdepth 2 \
            -name *.swp -prune -o \
            -name .git -prune -o -name .svn -prune -o \( -type f -o -type l \) \
            -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
    }
fi
if ! declare -f _fzf_compgen_dir_path > /dev/null; then
    _fzf_compgen_dir_path() {
        command find -L "$1" \
            -maxdepth 2 \
            -name .git -prune -o -name .svn -prune -o -type d \
            -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
    }
fi

_fzf_complete_cd_notrigger() {
    FZF_COMPLETION_TRIGGER='' __fzf_generic_path_completion _fzf_compgen_dir_path "" "/" "$@"
}

_fzf_complete_vim_notrigger() {
    FZF_COMPLETION_TRIGGER='' __fzf_generic_path_completion _fzf_compgen_file_path "-m" "" "$@"
}

complete -o bashdefault -o default -F _fzf_complete_cd_notrigger cd
complete -o bashdefault -o default -F _fzf_complete_vim_notrigger vim

# to ignore git modules we need the silver searcher
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore node_modules -g ""'
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
