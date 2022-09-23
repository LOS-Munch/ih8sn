# ih8sn

ih8sn allows you to modify system properties at runtime. It can be installed with ADB root or recovery. Proceed at your own risk.

## Disclaimer:

```
- The user takes sole responsibility for any damage that might arise due to use of this tool.
- This includes physical damage (to device), injury, data loss, and also legal matters.
- The developers cannot be held liable in any way for the use of this tool.
```

## Requirements

- Android platform tools
- Android device

## Installation

### 1: Download ih8sn

Check the "Releases" section on the right.

### 2: [Optional] Configure ih8sn.conf inside the zip for your device

- Modify ih8sn.conf for your device and save it as ih8sn.conf.`<codename>` in etc.
- Use # or remove it from config to disable spoofing that property.

Example :

```
BUILD_FINGERPRINT=OnePlus/OnePlus7Pro_EEA/OnePlus7Pro:10/QKQ1.190716.003/1910071200:user/release-keys
BUILD_DESCRIPTION=OnePlus7Pro-user 10 QKQ1.190716.003 1910071200 release-keys
BUILD_SECURITY_PATCH_DATE=2019-09-05
BUILD_TAGS=release-keys
BUILD_TYPE=user
BUILD_VERSION_RELEASE=10
BUILD_VERSION_RELEASE_OR_CODENAME=10
DEBUGGABLE=0
MANUFACTURER_NAME=OnePlus
PRODUCT_NAME=OnePlus7Pro
SECURE=1
```

### 3: Push the files to your device

#### 1. ADB root
```
- Extract ih8sn zip in your PC.
- Enable usb debugging and rooted debugging in developer options in your phone. 
```
Run the script according to your system.

Windows :
```
.\push.ps1
```
Linux :
```
./push.sh
```

#### 2. Recovery method
```
Reboot to recovery and select Apply update -> Apply from ADB
```
Run this in terminal.
```
adb sideload ih8sn*.zip
```

### 4: Reboot your device 
<br>

## Notes: 
```
- Run script or flash zip again to uninstall.
- Spoofing staying in ota updates if rom supports.
```