#!/bin/bash

source config
source hosts

# MRTG_ROOT="/var/www/mrtg"
COMMUNITY="public"

# Make configuration file
for HOST in $HOSTS
do
  COMMUNITY=$(echo $HOST|awk -F ":" '{ print $2 }')
  HOST=$(echo $HOST|awk -F ":" '{ print $1 }')
	if [ ! -d $MRTG_ROOT/data/$HOST ]; then
		echo "Creating directory for host: $HOST";
		mkdir -p $MRTG_ROOT/data/$HOST
	fi
	
	if [ ! -f $MRTG_ROOT/cfg/$HOST.cfg ]; then
		echo "Generating cfg for host: $HOST";
		/usr/bin/cfgmaker \
                --global 'WorkDir: '$MRTG_ROOT'/data/'$HOST \
                --global 'Options[_]: bits,growright' \
                --output $MRTG_ROOT/cfg/$HOST.cfg \
                --ifref=name,descr \
                --ifdesc=nr,descr \
		--zero-speed=1000000000 \
		--snmp-options=:::::1 \
                $COMMUNITY@$HOST
	else
		echo "Skipping $HOST"
	fi
done
