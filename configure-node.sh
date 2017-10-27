#!/bin/bash

BACKUP=./backup
ASSETS=./assets
CP="cp -iv"

if (( $EUID != 0 )); then
	echo "This script must be run as root." 1>&2
	exit 1
fi

cd $(dirname $0)

curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt install -y nodejs
