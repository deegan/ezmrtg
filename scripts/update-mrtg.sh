#!/bin/bash

# DIRCFG=/var/www/mrtg/cfg
# DIRHTML=/var/www/mrtg/
# CWD=/var/www/mrtg/scripts
source config
source hosts

for HOST in $HOSTS
do
        COMMUNITY=$(echo $HOST|awk -F ":" '{ print $2 }')
        HOST=$(echo $HOST|awk -F ":" '{ print $1 }')
        env LANG=C /usr/bin/mrtg --debug="cfg,snpo,time" $DIRCFG/$HOST.cfg --logging $DIRCFG/$HOST.log
done
$MRTG_ROOT/scripts/make-left.sh
