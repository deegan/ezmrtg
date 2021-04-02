#!/bin/bash

# DIRCFG="/var/www/mrtg/cfg"
# DIRHTML="/var/www/mrtg"

source config
source hosts

# Make index file
for HOST in $HOSTS
do
	/usr/bin/indexmaker --columns=1 $DIRCFG/$HOST.cfg > $DIRHTML/data/$HOST/index.html
done
