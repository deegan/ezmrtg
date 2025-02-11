#!/bin/bash

# DIRCFG=/var/www/mrtg/cfg
# DIRHTML=/var/www/mrtg/

source config
source hosts

function loop_restart() {
    for HOST in $HOSTS
    do
        COMMUNITY=$(echo $HOST|awk -F ":" '{ print $2 }')
        HOST=$(echo $HOST|awk -F ":" '{ print $1 }')
        if [ ! -e $DIRCFG/$HOST.cfg_l ]
        then
            echo -n "$HOST: "
            env LANG=C /usr/bin/mrtg --daemon $DIRCFG/$HOST.cfg --logging $DIRCFG/$HOST.log
        else
            echo "$HOST is already running, skipping..."
        fi
    done
}

function single_restart(){
    if [ $1 ]
        echo "Restarting $HOST daemon..."
    fi
}

if [ -z $1 ]
then
    echo "Restart all mrtg daemons? [y/n]: "
    read -a ANS -p
    case "$ANS" in
        y)
        loop_restart
        ;;
        n)
        break;
        ;;
        *)
        break;;
    esac
else
