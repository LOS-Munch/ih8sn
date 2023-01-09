#!/usr/bin/env pwsh

$out = "system/bin"
New-Item -ItemType Directory -Force -Path ${out} | Out-Null

$ndk_version = "r25b"

if (!(Test-Path -Path "android-ndk")) {
    if (!(Test-Path "android-ndk-${ndk_version}-windows.zip" -PathType leaf)) {
        echo "Downloading Android NDK"
        Invoke-WebRequest -Uri "https://dl.google.com/android/repository/android-ndk-${ndk_version}-windows.zip" -OutFile "android-ndk-${ndk_version}-windows.zip"
    }
    Expand-Archive "android-ndk-${ndk_version}-windows.zip" -DestinationPath .
    Rename-Item "android-ndk-${ndk_version}" "android-ndk"
}

./android-ndk/toolchains/llvm/prebuilt/windows-x86_64/bin/aarch64-linux-android33-clang++ -Iaosp/bionic/libc `
    -Iaosp/bionic/libc/async_safe/include `
    -Iaosp/bionic/libc/system_properties/include `
    -Iaosp/system/core/base/include `
    -Iaosp/system/core/property_service/libpropertyinfoparser/include `
    aosp/bionic/libc/bionic/system_property_api.cpp `
    aosp/bionic/libc/bionic/system_property_set.cpp `
    aosp/bionic/libc/system_properties/context_node.cpp `
    aosp/bionic/libc/system_properties/contexts_serialized.cpp `
    aosp/bionic/libc/system_properties/contexts_split.cpp `
    aosp/bionic/libc/system_properties/prop_area.cpp `
    aosp/bionic/libc/system_properties/prop_info.cpp `
    aosp/bionic/libc/system_properties/system_properties.cpp `
    aosp/system/core/base/strings.cpp `
    aosp/system/core/property_service/libpropertyinfoparser/property_info_parser.cpp `
    main.cpp -static -std=c++17 -o ${out}/ih8sn

read-host "Press any key to exit..."
