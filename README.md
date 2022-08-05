# Nvidia driver compiled to Slackware 15.0

## Tested in one laptop with Nvidia GeForce 940MX

## Version
    Nvidia driver: 515.57
    Slackware 15.0 Kernel: 5.15.38

## Links
1. https://docs.slackware.com/howtos:hardware:nvidia_optimus
2. https://docs.slackware.com/howtos:hardware:nvidia_optimus#official_optimus_support_with_the_nvidia_proprietary_driver
3. https://docs.slackware.com/howtos:hardware:proprietary_graphics_drivers
4. https://download.nvidia.com/XFree86/Linux-x86_64/450.80.02/README/primerenderoffload.html
5. https://wiki.archlinux.org/index.php/bumblebee#Configuration
6. https://wiki.debian.org/NVIDIA%20Optimus
7. http://www.nvidia.com/object/unix.html

# Alternative - use Bumblebee
https://github.com/ryuuzaki42/24_Bumblebee-SlackBuilds-Packages/

## How Install

### 1 Download the latest version that matches with the kernel in use and unzip:
    14_Nvidia_Driver_Slackware_Laptop_<driver version>_<kernel version>.zip
https://github.com/ryuuzaki42/14_Nvidia_Driver_Slackware_Laptop/releases/

### 2 Login as root and upgradepkg xf86-video-nouveau-blacklist
    su -
    cd 14_nvidia_drive_SlackBuilds_Packages/final_packages/
    upgradepkg upgrade/xf86-video-nouveau-blacklist-1.0-noarch-1.txz

### 3 Install/upgrade nvidia-driver and nvidia-kernel
    upgradepkg --install-new --reinstall nvidia-driver-*z nvidia-kernel-*z

### 4 Add the config file
```
echo 'Section "ServerLayout"
    Identifier "layout"
    Option "AllowNVIDIAGPUScreens"
    Screen 0 "iGPU"
EndSection

Section "Device"
    Identifier "iGPU"
    Driver "modesetting"
EndSection

Section "Screen"
    Identifier "iGPU"
    Device "iGPU"
EndSection

Section "Device"
    Identifier "nvidia"
    Driver "nvidia"
EndSection' > /etc/X11/xorg.conf.d/21-LAR-nvidia-screens.conf
```

### 5 Reboot to test

    xrandr --listproviders
Should display a provider named NVIDIA-G0 (for “NVIDIA GPU screen 0”).

    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxinfo | grep 'OpenGL vendor'
Should display:
OpenGL vendor string: NVIDIA Corporation

    glxinfo | grep 'OpenGL vendor'
Should display your integrated GPU's' vendor as opposed to NVIDIA (e.g., Intel).

## To run games on Steam
https://wiki.debian.org/NVIDIA%20Optimus#Using_NVIDIA_PRIME_Render_Offload

    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%

### With mangohud
    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia mangohud %command%

### If you use slackpkg+ ([http://slakfinder.org/slackpkg+.html](http://slakfinder.org/slackpkg+.html)), Set nouveau to greylist:
    echo "xf86-video-nouveau" >> /etc/slackpkg/greylist

### After a kernel update need will to rebuilt nvidia-kernel

### Build using scripts based on:
https://slackbuilds.org/repository/15.0/system/nvidia-kernel/

https://slackbuilds.org/repository/15.0/system/nvidia-driver/ with COMPAT32="yes"
