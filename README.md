# ih8sn

- ih8sn allows you to modify system properties at runtime.
-  It can be installed with ADB root or recovery.
- If you want to add your device, do a PR with your device config.

## Disclaimer:

```
- The user takes sole responsibility for any damage that might arise due to use of this tool.
- This includes physical damage (to device), injury, data loss, and also legal matters.
- The developers cannot be held liable in any way for the use of this tool.
```

# Inline building

### 1: Clone ih8sn repo
```
git clone https://github.com/LOS-Munch/ih8sn ih8sn
```

### 2: Include makefile
```
$(call inherit-product-if-exists, ih8sn/product.mk)
```

## Requirements for recovery/adb root

- Android platform tools
- Android device

# Installation

## 1: Download ih8sn

Check the "Releases" section on the right. Make sure to download correct zip for your device `<arch>`.

- aarch64 = arm64
- armv7a = arm
- i686 = x86
- x86_64 = x86_64

## 2: Check if your device is supported in system/etc/ih8sn.conf.<codename/model>
- If your device isn't available in the list then you can either use default config by flashing exisiting ih8sn flashable zip or follow below steps to create ih8sn config for your device.

### Configure ih8sn.conf for your device
- Modify ih8sn.conf for your device and save it as ih8sn.conf.`<codename>` in etc.
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
PRODUCT_FIRST_API_LEVEL=29
```

Notes:
- Use # or remove it from config to disable spoofing that property.
- You don't need to spoof all the properties.

## 3: Push the files to your device

#### 1. ADB root

- Extract ih8sn-`<arch>`.zip in your PC.
- Enable usb debugging and rooted debugging in developer options in your phone. 

Run the script according to your system.

Windows (Install):
```
.\push.ps1
```
Windows (Uninstall):
```
.\uninstall.ps1
```
Linux (Install) :
```
./push.sh
```
Linux (Uninstall) :
```
./uninstall.sh
```

#### 2. Recovery method

- Reboot to recovery and select Apply update -> Apply from ADB
- Run this in terminal to install.
```
adb sideload ih8sn-<arch>.zip
```

To uninstall.
```
adb sideload ih8sn-uninstaller.zip
```

## 4: Reboot your device 

## Notes: 
- Spoofing staying in ota updates if the rom supports it.
