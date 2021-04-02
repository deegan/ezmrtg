#!/bin/bash

source config
source hosts

# Make configuration file
for HOST in $HOSTS
do
	env LANG=C /usr/bin/mrtg $DIRCFG/$HOST.cfg
done
