# Nvidia driver compiled to Slackware 15.0

## Version
    Nvidia driver: 515.57
    Slackware 15.0 Kernel: 5.15.38

## Links

[http://www.nvidia.com/object/unix.html](http://www.nvidia.com/object/unix.html)

[https://wiki.archlinux.org/index.php/bumblebee#Configuration](https://wiki.archlinux.org/index.php/bumblebee#Configuration)

[https://docs.slackware.com/howtos:hardware:nvidia_optimus](https://docs.slackware.com/howtos:hardware:nvidia_optimus)

[https://docs.slackware.com/howtos:hardware:proprietary_graphics_drivers](https://docs.slackware.com/howtos:hardware:proprietary_graphics_drivers)

# Alternative - use Bumblebee
[https://github.com/ryuuzaki42/24_Bumblebee-SlackBuilds-Packages/](https://github.com/ryuuzaki42/24_Bumblebee-SlackBuilds-Packages/)

## How Install

### 0 - clone the repository or donwload
    git clone https://github.com/ryuuzaki42/14_nvidia_drive_SlackBuilds_Packages.git

### Or download
[https://github.com/ryuuzaki42/14_nvidia_drive_SlackBuilds_Packages/archive/master.zip](https://github.com/ryuuzaki42/14_nvidia_drive_SlackBuilds_Packages/archive/master.zip)

### 1 Login as root and upgradepkg xf86-video-nouveau-blacklist
    su -
    cd 14_nvidia_drive_SlackBuilds_Packages/final_packages/
    upgradepkg upgrade/xf86-video-nouveau-blacklist-1.0-noarch-1.txz

### 2 Install/upgrade nvidia-driver and nvidia-kernel
    cd ../
    upgradepkg --install-new --reinstall nvidia-driver-*z nvidia-kernel-*z

### 3 Add the config file
    nano /etc/X11/xorg.conf.d/21-LAR-nvidia-screens.conf

    Section "ServerLayout"
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
    EndSection

### Reboot to test
    xrandr --listproviders
Should display a provider named NVIDIA-G0 (for “NVIDIA GPU screen 0”).

    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxinfo | grep 'OpenGL vendor'
Should display:
OpenGL vendor string: NVIDIA Corporation

    glxinfo | grep 'OpenGL vendor'
Should display your integrated GPU's' vendor as opposed to NVIDIA (e.g., Intel).

    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxgears

## To run games on Steam
    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%

### With mangohud
    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia mangohud %command%

### If you use slackpkg+ ([http://slakfinder.org/slackpkg+.html](http://slakfinder.org/slackpkg+.html)), Set nouveau to greylist:
    echo "xf86-video-nouveau" >> /etc/slackpkg/greylist

### After a Kernel update need to rebuilt nvidia-driver and nvidia-kernel

### Build using scripts based in:
https://slackbuilds.org/repository/15.0/system/nvidia-kernel/
https://slackbuilds.org/repository/15.0/system/nvidia-driver/
    COMPAT32="yes" ./nvidia-driver.SlackBuild
