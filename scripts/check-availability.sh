#!/bin/bash

source hosts

num_rows=$(echo ${#HOSTS})
inc="1"
for host in $HOSTS; do
    printf '%s\r' "Checking hosts: [$inc/$num_rows]"
    inc=$[$inc +1]
    snmpwalk -v2c -c public $host 2> /dev/null
    if [ $? = 0 ]; then
        echo $host >> goodip
    fi
done
