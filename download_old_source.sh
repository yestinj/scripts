#!/bin/bash

set -e
set -o pipefail

if [ "$#" -ne 2 ]; then
    echo "Usage: download_old_source.sh <package_name> <version>"
    exit 1
fi

PACKAGE_NAME=$1

SOURCE_NAME="$(dpkg -s ${PACKAGE_NAME} | grep Source: | cut -d ' ' -f2)"
if [ -z "${SOURCE_NAME}" ]; then
    SOURCE_NAME=$PACKAGE_NAME
fi

VERSION=$2

echo "Downloading source for package $PACKAGE_NAME $VERSION"
echo "This package is built from source: $SOURCE_NAME" 

pwd=$(pwd)
echo "Creating directory ${SOURCE_NAME}"
mkdir -p "${SOURCE_NAME}"
cd "${SOURCE_NAME}"

echo "Downloading source files from launchpad.net"
wget -q -O - "https://launchpad.net/ubuntu/+source/$SOURCE_NAME/$VERSION" | grep 'https://launchpad.net/ubuntu/+archive/primary/+files/' | cut -d \" -f2 | xargs wget -q

if [ $? != 0]; then
    echo "Download failed! Aborting"
    exit 1
fi

echo "Downloads complete"

cd "${pwd}"
FILENAME="${SOURCE_NAME}_${VERSION}.tar.bz2"
echo "Archiving source folder ${SOURCE_NAME} to ${FILENAME}"
tar -cjf "${FILENAME}" "${SOURCE_NAME}/"

if [ $? -eq 0 ]; then
    echo "Archiving complete"
    echo "Removing directory ${SOURCE_NAME}"
    rm -r "${SOURCE_NAME}"
else
    echo "Archive did not complete successfully. Source folder not removed!"
fi

echo "Completed fetching source for $SOURCE_NAME $VERSION"
