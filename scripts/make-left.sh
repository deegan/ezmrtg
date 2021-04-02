#!/bin/bash

source config

rm $MRTG_ROOT/left.html

for dir in `ls $MRTG_ROOT/data`; do
    echo "<a href="$MRTG_ROOT/data/$dir/index.html" target="main">$dir</a><br>" >> $MRTG_ROOT/left.html
done
