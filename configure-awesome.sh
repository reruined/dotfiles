#!/bin/bash

BACKUP=./backup
ASSETS=./assets
CP="cp -ivr"
RM="rm -rfv"
LN="ln -svi"
function realpath { echo $(cd $(dirname $1); pwd)/$(basename $1); }

if (( $EUID == 0 )); then
	echo "This script must be NOT run as root." 1>&2
	exit 1
fi

cd $(dirname $0)

# remember xsession!
sudo apt install awesome awesome-extra rxvt-unicode-256color physlock fonts-dejavu-extra upower &&
$CP ~/.config/awesome ~/.xsession ~/.Xresources $BACKUP/
$RM ~/.config/awesome ~/.xsession ~/.Xresources
$LN $(realpath "$ASSETS/awesome") ~/.config/awesome &&
$LN $(realpath "$ASSETS/.xsession") ~/.xsession &&
$LN $(realpath "$ASSETS/.Xresources") ~/.Xresources &&
xrdb -merge ~/.Xresources

