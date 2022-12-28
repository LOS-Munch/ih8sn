#!/bin/bash

while getopts ":-:" o; do
    case "${OPTARG}" in
        reboot)
            REBOOT=1
            ;;
        use_remount)
            USE_REMOUNT=1
            ;;
    esac
done

adb wait-for-device root
adb wait-for-device shell "mount | grep -q ^tmpfs\ on\ /system && umount -fl /system/{bin,etc} 2>/dev/null"
if [[ "${USE_REMOUNT}" = "1" ]]; then
    adb wait-for-device shell "remount"
elif [[ "$(adb shell stat -f --format %a /system)" = "0" ]]; then
    echo "ERROR: /system has 0 available blocks, consider using --use_remount"
    exit -1
else
    adb wait-for-device shell "stat --format %m /system | xargs mount -o rw,remount"
fi

if [ $(adb shell find /system -name "*ih8sn*" | wc -l) -gt 0 ]; then
    echo "Removing existing ih8sn files"
    adb wait-for-device shell "find /system -name *ih8sn* -delete"
else
    echo "No ih8sn files found"
fi

if [[ "${REBOOT}" = "1" ]]; then
    adb wait-for-device reboot
fi

read -p "Press any key to exit..." && exit
