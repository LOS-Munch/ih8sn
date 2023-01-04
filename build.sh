#!/bin/bash

set -e

folder=$(dirname -- "$(readlink -f -- "$0")")
files="system push.sh"
script_dir="META-INF/com/google/android/"
zip_name="ih8sn-$1.zip"
bin_out="$folder/system/bin"

if [ -z "$1" ]; then
    $0 armv7a
    $0 aarch64
    $0 i686
    $0 x86_64
    $0 uninstall
    exit 0
elif [[ ! "aarch64 armv7a i686 x86_64 uninstall" =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
    echo "Unknown type $1"
    exit 0
fi

mkdir -p $bin_out $folder/tmp/$script_dir

ndk_version=r25b

if [ ! -d android-ndk-$ndk_version ]; then
    if [ ! -f android-ndk-$ndk_version-linux.zip ]; then
        echo "Downloading Android NDK"
        wget -q --show-progress https://dl.google.com/android/repository/android-ndk-$ndk_version-linux.zip
    fi
    echo "Extracting Android NDK"
    unzip -q android-ndk-$ndk_version-linux.zip
fi

export PATH=${PATH}:$folder/android-ndk-$ndk_version/toolchains/llvm/prebuilt/linux-x86_64/bin

echo "Building ih8sn archive for $1"
if [ $1 '==' "armv7a" ]; then
    CXX=${CXX:-armv7a-linux-androideabi33-clang++}
elif [ $1 '==' "aarch64" ]; then
    CXX=${CXX:-aarch64-linux-android33-clang++}
elif [ $1 '==' "i686" ]; then
    CXX=${CXX:-i686-linux-android33-clang++}
elif [ $1 '==' "x86_64" ]; then
    CXX=${CXX:-x86_64-linux-android33-clang++}
fi

if [ ! -z "$CXX" ]; then
    ${CXX} \
        -Iaosp/bionic/libc \
        -Iaosp/bionic/libc/async_safe/include \
        -Iaosp/bionic/libc/system_properties/include \
        -Iaosp/system/core/base/include \
        -Iaosp/system/core/property_service/libpropertyinfoparser/include \
        aosp/bionic/libc/bionic/system_property_api.cpp \
        aosp/bionic/libc/bionic/system_property_set.cpp \
        aosp/bionic/libc/system_properties/context_node.cpp \
        aosp/bionic/libc/system_properties/contexts_serialized.cpp \
        aosp/bionic/libc/system_properties/contexts_split.cpp \
        aosp/bionic/libc/system_properties/prop_area.cpp \
        aosp/bionic/libc/system_properties/prop_info.cpp \
        aosp/bionic/libc/system_properties/system_properties.cpp \
        aosp/system/core/base/strings.cpp \
        aosp/system/core/property_service/libpropertyinfoparser/property_info_parser.cpp \
        main.cpp \
        -static \
        -std=c++17 \
        -o $bin_out/ih8sn
fi

cp $folder/scripts/updater-script $folder/tmp/$script_dir/updater-script

if [ $1 == "uninstall" ]; then
    cat $folder/scripts/update-binary $folder/scripts/update-binary_uninstall >$folder/tmp/$script_dir/update-binary
    zip_name="ih8sn-uninstaller.zip"
    cp -r uninstall.sh $folder/tmp/
else
    cp -r $files $folder/tmp/
    cat $folder/scripts/update-binary $folder/scripts/update-binary_install >$folder/tmp/$script_dir/update-binary
fi

cd $folder/tmp
zip -q -r $folder/$zip_name *

if [ -d $folder/tmp ]; then
    rm -rf $folder/tmp
fi
