#!/bin/bash
TARGET=$1
cd $TARGET
for i in $( seq 1 1000 );
do
    fn=file-$i
    touch $fn 
done 
