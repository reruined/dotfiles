#!/bin/bash
path=~/.vim
vimpath=~/Repositories/dotfiles/assets/vim
vpppath=~/Repositories/dotfiles/assets/vpp
realpath=$(readlink -- "$path")
echo "$path points to $realpath"

if [[ $realpath != *"vpp"* ]]; then
    echo "> vim config is used"
    ln -sfvn $vpppath $path
else
    echo "> vpp config is used"
    ln -sfvn $vimpath $path
fi

realpath=$(readlink -- "$path")
echo "$path now points to $realpath"

if [[ $realpath != *"vpp"* ]]; then
    echo "> vim config active!"
else
    echo "> vpp config active!"
fi
