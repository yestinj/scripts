#!/bin/bash
#Moves all files in subdirectories of the target directory into the given target directory.
TARGET_DIR=$1
cd ${TARGET_DIR}
for i in $( find . -mindepth 1 -maxdepth 1 -type d );
do
    FULL_PATH=$TARGET_DIR/$i
    FC=$(find $FULL_PATH -mindepth 1 -maxdepth 1 -type f | wc -l)
    if [ $FC -gt 0 ]; then
	mv -v $FULL_PATH/* -t $TARGET_DIR
    fi
done
