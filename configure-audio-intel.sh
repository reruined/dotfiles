#!/bin/bash

if (( $EUID != 0 )); then
	echo "This script must be run as root." 1>&2
	exit 1
fi

apt install alsa-utils saytime &&\
saytime
