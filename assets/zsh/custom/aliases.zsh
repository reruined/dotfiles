#!/bin/zsh
alias l="ls -sh1 --file-type --time-style=long-iso"
alias laa="ls -1 --almost-all --file-type -l -h --time-style=long-iso"
alias la="l --almost-all"
alias pause="pkill --signal SIGSTOP"
alias unpause="pkill --signal SIGCONT"
alias rm="rm -vi"
alias mv="mv -v"
alias cp="cp -vr"
alias trash="trash -v"
alias tmux="tmux -2 -u"
alias t="tmux new-session -A -s default"
alias feh="feh --scale-down --image-bg=black"

alias gits="git status"
alias gita="git add -p"
alias gitc="git commit"
alias gitl="git log --decorate --graph --date=relative --pretty=medium --abbrev-commit --name-status"
alias gitall="git add -A ."
alias gbranch="git rev-parse --abbrev-ref HEAD"
alias s="git status"

alias las="du -hcs ./{*(N),.*(N)} | sort -hr"
alias glögg=glog

first=~/Repositories/ikea-first
algot=~/Repositories/ikea-algot
goat=~/Repositories/goat

function git-examine {
   git difftool $1 $(git merge-base $1 $2) 
}

function git-obliterate {
   echo Obliterating git branch $1...
   git push origin --delete $1
   git branch -d $1
   git fetch origin --prune
   echo Done obliterating git branch $1!
}
