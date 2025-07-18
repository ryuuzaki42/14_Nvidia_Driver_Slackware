# Nvidia driver and kernel compiled to Slackware

## Version
    Nvidia driver: 570.169
    Slackware 15.0 Kernel: 5.15.188

### Last update: 16/07/2025

## Tested in laptops with Nvidia GeForce 930MX and 940MX
    # lspci -v | grep "NVIDIA"

    $ nvidia-smi -L

## Links
1. https://docs.slackware.com/howtos:hardware:nvidia_optimus
2. https://docs.slackware.com/howtos:hardware:nvidia_optimus#official_optimus_support_with_the_nvidia_proprietary_driver
3. https://docs.slackware.com/howtos:hardware:proprietary_graphics_drivers
4. https://download.nvidia.com/XFree86/Linux-x86_64/570.169/README/primerenderoffload.html
5. https://wiki.archlinux.org/title/NVIDIA
6. https://wiki.debian.org/NVIDIA%20Optimus
7. https://www.nvidia.com/object/unix.html

## Alternative - use Bumblebee
https://github.com/ryuuzaki42/24_Bumblebee-SlackBuilds-Packages/

## How Install

### 1. Download the latest release version that matches with the kernel in use and extract:
    14_Nvidia_Driver_Slackware_<driver version>_<kernel version>.zip

https://github.com/ryuuzaki42/14_Nvidia_Driver_Slackware/releases/

### The latest update
https://github.com/ryuuzaki42/14_Nvidia_Driver_Slackware/releases/latest

### 2. Login as root and upgradepkg xf86-video-nouveau-blacklist
    cd 14_Nvidia_Driver_Slackware*/final_packages/
    su
    upgradepkg upgrade/xf86-video-nouveau-blacklist-1.0-noarch-1.txz

### 3. Install / Upgrade nvidia-driver and nvidia-kernel
    upgradepkg --install-new --reinstall nvidia-driver-*z nvidia-kernel-*z

### 4. Add the configuration file
    cp 21-LAR-nvidia-screens.conf /etc/X11/xorg.conf.d/21-LAR-nvidia-screens.conf

### 5. Reboot your system to take effect

## Test
    xrandr --listproviders
Should display a provider named NVIDIA-G0 (for “NVIDIA GPU screen 0”)

    glxinfo | grep "OpenGL vendor"
Should display your integrated GPU's' vendor as opposed to NVIDIA (e.g., Intel)

    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxinfo | grep "OpenGL vendor"
Should display: "OpenGL vendor string: NVIDIA Corporation"

## To run games on Steam
https://wiki.debian.org/NVIDIA%20Optimus#Using_NVIDIA_PRIME_Render_Offload

    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%

### With mangohud
    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia mangohud %command%

## If you use slackpkg+, set nouveau to greylist:
https://slakfinder.org/slackpkg+.html

    echo "xf86-video-nouveau" >> /etc/slackpkg/greylist

## After a kernel update will need to rebuilt nvidia-kernel

## Build using scripts based on:
https://slackbuilds.org/repository/15.0/system/nvidia-kernel/

https://slackbuilds.org/repository/15.0/system/nvidia-driver/ with COMPAT32="yes"
