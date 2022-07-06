#!/bin/bash

if [ -d system ]; then
    rm -rf system
fi

if [ -f ih8sn.zip ]; then
    rm ih8sn.zip
fi

if [ ! -f ih8sn ]; then
    echo "Build ih8sn first"
    exit 0
fi

mkdir -p system/addon.d system/bin system/etc/init

cp ih8sn system/bin/
cp ih8sn.rc system/etc/init/
cp ih8sn.conf system/etc/
cp 60-ih8sn.sh system/addon.d/

zip -r -q ih8sn.zip system META-INF
