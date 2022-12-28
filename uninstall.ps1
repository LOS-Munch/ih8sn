#!/usr/bin/env pwsh

param(
    [switch]$reboot = $false,
    [switch]$use_remount = $false
)

adb wait-for-device root
adb wait-for-device shell "mount | grep -q ^tmpfs\ on\ /system && umount -fl /system/{bin,etc} 2>/dev/null"
if ($use_remount) {
    adb wait-for-device shell "remount"
} elseif ((adb shell stat -f --format %a /system) -eq "0") {
    Write-Error "ERROR: /system has 0 available blocks, consider using -use_remount" -ErrorAction Stop
} else {
    adb wait-for-device shell "stat --format %m /system | xargs mount -o rw,remount"
}

if ((adb shell 'ls /system/bin/ih8sn 2> /dev/null') -eq "/system/bin/ih8sn") {
    echo "Removing existing ih8sn files"
    adb wait-for-device shell "find /system -name *ih8sn* -delete"
}

if ($reboot) {
    adb wait-for-device reboot
}

read-host “Press any key to exit...”
