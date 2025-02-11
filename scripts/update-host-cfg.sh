#!/bin/bash

source config
source hosts

# Make configuration file
for HOST in $HOSTS
do
  COMMUNITY=$(echo $HOST|awk -F ":" '{ print $2 }')
  HOST=$(echo $HOST|awk -F ":" '{ print $1 }')
	env LANG=C /usr/bin/mrtg $DIRCFG/$HOST.cfg
done
