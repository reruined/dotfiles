#!/bin/bash

BACKUP=./backup
ASSETS=./assets
CP="cp -iv"

if (( $EUID != 0 )); then
	echo "This script must be run as root." 1>&2
	exit 1
fi

apt install curl wget apt-transport-https dirmngr &&\
curl https://www.franzoni.eu/keys/D401AB61.txt | apt-key add - &&\
wget http://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb && dpkg -i deb-multimedia-keyring_2016.8.1_all.deb &&\
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys FC918B335044912E &&\
wget -O - http://deb.opera.com/archive.key | apt-key add - &&\
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F24AEA9FB05498B7 &&\
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add - &&\
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add - &&\
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg &&\
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 2CC26F777B8B44A1 &&\
$CP /etc/apt/sources.list $BACKUP &&\
$CP $ASSETS/sources.list /etc/apt/sources.list &&\
apt update
