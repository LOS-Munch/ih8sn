#!/bin/bash

set -e

if [ -z "$1" ]; then
    exit 0
fi

folder=$(dirname -- "$( readlink -f -- "$0"; )")
files="system push.ps1 push.sh"
script_dir="META-INF/com/google/android/"
zip_name="ih8sn-$1.zip"

mkdir -p $folder/tmp/$script_dir
cp $folder/scripts/updater-script $folder/tmp/$script_dir/updater-script

if [ $1 == "uninstall" ]; then
    cat $folder/scripts/update-binary $folder/scripts/update-binary_uninstall > $folder/tmp/$script_dir/update-binary
    zip_name="ih8sn-uninstaller.zip"
    cp -r uninstall.* $folder/tmp/
else
    cp -r $files $folder/tmp/
    cat $folder/scripts/update-binary $folder/scripts/update-binary_install > $folder/tmp/$script_dir/update-binary
fi

if [[ "aarch64 armv7a i686 x86_64 uninstall" =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
    cd $folder/tmp
    zip -r $folder/$zip_name *
else
    echo "Unknown type $1"
fi

if [ -d $folder/tmp ]; then
    rm -rf $folder/tmp
fi
