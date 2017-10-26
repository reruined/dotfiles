#!/bin/bash

BACKUP=./backup
ASSETS=./assets
CP="cp -ivr"
RM="rm -rfv"

if (( $EUID == 0 )); then
	echo "This script must NOT be run as root." 1>&2
	exit 1
fi

cd $(dirname $0)

function realpath { echo $(cd $(dirname $1); pwd)/$(basename $1); }

sudo apt install curl git zsh &&\
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &&\
$CP ~/.oh-my-zsh/custom ~/.zshrc $BACKUP/ ;\
$RM ~/.oh-my-zsh/custom ~/.zshrc &&\
ln -svi $(realpath "$ASSETS/zsh/custom") ~/.oh-my-zsh/custom &&\
ln -svi $(realpath "$ASSETS/zsh/.zshrc") ~/.zshrc
