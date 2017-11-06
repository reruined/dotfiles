#!/bin/bash -x

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

$CP ~/.vim ~/.vimrc $BACKUP/
$RM ~/.vim ~/.vimrc
sudo apt purge vim vim-runtime gvim vim-tiny vim-common vim-gui-common vim-nox &&
$LN $(realpath "$ASSETS/vim") ~/.vim
sudo apt install python-dev python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git build-essential cmake mono-devel golang rustc cargo &&
#sudo apt build-dep vim &&
cd ./vim
make distclean &&
./configure --with-features=huge \
            --enable-multibyte \
            --disable-gui \
            --enable-fail-if-missing \
            --enable-luainterp \
            --enable-perlinterp \
            --enable-pythoninterp \
            --enable-python3interp \
            --enable-rubyinterp \
            --enable-cscope \
            --enable-terminal &&
make &&
sudo make install &&
cd - &&
vim +PlugInstall +qall &&

(
	cd $(realpath $ASSETS/vim/plugged/YouCompleteMe); ./install.py --all; cd -

	sudo update-alternatives --install /usr/bin/editor editor $(which vim) 1
	sudo update-alternatives --set editor $(which vim)
	sudo update-alternatives --install /usr/bin/vi vi $(which vim) 1	
	sudo update-alternatives --set vi /usr/bin/vim
)
