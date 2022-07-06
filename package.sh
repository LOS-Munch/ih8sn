#!/bin/bash

if [ -d system ]; then
    rm -rf system
fi

if [ -f "*.zip" ]; then
    rm "*.zip"
fi

if [ ! -f ih8sn ]; then
    ./build.sh
fi

mkdir -p system/addon.d system/bin system/etc/init

cp ih8sn system/bin/
cp ih8sn.rc system/etc/init/
cp ih8sn.conf system/etc/
cp 60-ih8sn.sh system/addon.d/

zip -r -q ih8sn.zip system META-INF
java -jar zipsigner.jar ih8sn.zip ih8sn_signed.zip && rm ih8sn.zip
