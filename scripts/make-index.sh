#!/bin/bash

# DIRCFG="/var/www/mrtg/cfg"
# DIRHTML="/var/www/mrtg"

source config
source hosts

# Make index file
for HOST in $HOSTS
do
  COMMUNITY=$(echo $HOST|awk -F ":" '{ print $2 }')
  HOST=$(echo $HOST|awk -F ":" '{ print $1 }')
	/usr/bin/indexmaker --columns=1 $DIRCFG/$HOST.cfg > $DIRHTML/data/$HOST/index.html
done
