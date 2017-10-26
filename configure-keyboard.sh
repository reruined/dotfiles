#!/bin/bash

BACKUP=./backup
ASSETS=./assets
CP="cp -iv"

if (( $EUID != 0 )); then
	echo "This script must be run as root." 1>&2
	exit 1
fi

cd $(dirname $0)

$CP /etc/default/keyboard $BACKUP &&\
$CP $ASSETS/keyboard /etc/default/keyboard &&\
udevadm trigger --subsystem-match=input --action=change
