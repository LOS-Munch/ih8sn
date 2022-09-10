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

if ("adb shell 'ls /system/bin/ih8sn 2> /dev/null'" -eq "/system/bin/ih8sn") {
    echo "Removing existing ih8sn files"
    adb wait-for-device shell "find /system -name *ih8sn* -delete"
    exit
}

adb wait-for-device push system/addon.d/60-ih8sn.sh /system/addon.d/
adb wait-for-device push system/bin/ih8sn /system/bin/
adb wait-for-device push system/etc/init/ih8sn.rc /system/etc/init/

$device = adb shell getprop ro.product.device
$serialno = adb shell getprop ro.boot.serialno
$product = adb shell getprop ro.build.product

if (Test-Path "system/etc/ih8sn.conf.${serialno}" -PathType leaf) {
    adb wait-for-device push system/etc/ih8sn.conf.${serialno} /system/etc/ih8sn.conf
} elseif (Test-Path "system/etc/ih8sn.conf.${device}" -PathType leaf) {
    adb wait-for-device push system/etc/ih8sn.conf.${device} /system/etc/ih8sn.conf
} elseif (Test-Path "system/etc/ih8sn.conf.${product}" -PathType leaf) {
    adb wait-for-device push system/etc/ih8sn.conf.${product} /system/etc/ih8sn.conf
} else {
    adb wait-for-device push system/etc/ih8sn.conf /system/etc/
}

if ($reboot) {
    adb wait-for-device reboot
}
