#!/bin/bash
TARGET_DIRECTORY=$1
BATCH_SIZE=10
LOWER=1
UPPER=100
cd $TARGET_DIRECTORY
for i in $( seq $LOWER $UPPER );
do
    #echo Making directory $i...
    SUB=$TARGET_DIRECTORY/$i
    mkdir $SUB
    find $TARGET_DIRECTORY -mindepth 1 -maxdepth 1 -type f | head -$BATCH_SIZE | xargs mv -t $SUB/
done
