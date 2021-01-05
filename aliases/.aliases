# Tmux aliases
alias tn="tmux -u new -s"
alias ta="tmux -u attach -t"
alias tl="tmux -u ls"

# Git aliases
alias glog='git log --date-order --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias gl='glog --graph'
alias gs='git status -sb'
alias gfix="git commit -am \"fixup! $(git log -1 --format='%s' $@ > /dev/null 2>&1)\";git rebase -i --autosquash HEAD~2"
