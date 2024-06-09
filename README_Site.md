
## Link source
https://docs.slackware.com/howtos:hardware:nvidia_optimus#official_optimus_support_with_the_nvidia_proprietary_driver
https://download.nvidia.com/XFree86/Linux-x86_64/450.80.02/README/primerenderoffload.html


## Official Optimus Support with the nVidia Proprietary Driver

### Note
This will not work with Slackware 14.2 or any stable version of Slackware, as at the time of writing. Slackware Current is required.

### Dependencies/Requirements

#### From main -current tree:

    xorg-server >= 1.20.7

Do not try this with older versions - it will not work. Certain specific git commits are required to have been added to xorg-server;
see the official nVidia documentation linked to in the Sources section. These commits are only present in versions >= 1.20.7.

    xf86-video-nouveau-blacklist >= 1.0 or xf86-video-nouveau >= “blacklist”

Patrick Volkerding recently changed 'blacklist' from being the version number which would trample over the actual package containing the
module, to 'blacklist' being part of the package-name with '1.0' being the version number. Either one is fine; just be aware of this.

The one with the package-name 'xf86-video-nouveau-blacklist' will coexist with xf86-video-nouveau, which is fine. The important thing is
that /etc/modprobe.d/BLACKLIST-nouveau.conf be present on your system, which will ensure that the nouveau module is properly blacklisted.

### From SlackBuilds.org:

    nvidia-kernel >= 435.17

Build normally. I got a gcc mismatch error as I am using a kernel that is quite old. I was able to override it successfully by adding
the environment variable spouted out by the nvidia installer during the build process when it failed the first time. YMMV. For best results,
build nvidia-kernel using the same version of gcc that was used to build the kernel itself.

    nvidia-driver >= 435.17

Be sure to build with CURRENT=“yes” and optionally with COMPAT32=“yes” in the custom build options of the SlackBuild.
The nvidia-switch scripts are not required with -current as libglvnd is now included in mainline -current.

### Next Steps

Once you have the packages listed above installed, I would recommend rebooting. Is this strictly necessary? Probably not, but in my experience
when you start playing around with kernel modules involving graphics drivers, it is a best practice to reboot, because it is easy to think you have
a working setup only to find that it didn't survive a reboot (and chances are, by then you will have forgotten what you did to make it work).

I would also recommend changing your runlevel to 3 if it is currently 4.

Once you have rebooted into runlevel 3, ensure that the nvidia_drm module has been successfully loaded:

$ lsmod |grep nvidia_drm

As root, add the following to /etc/X11/xorg.conf.d/21-LAR-nvidia-screens.conf (or any filename you would like):

    # cat << EOF > /etc/X11/xorg.conf.d/21-LAR-nvidia-screens.conf
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
    EOF

Note that the official nVidia documentation seems to indicate you only need the following:

    Section "ServerLayout"
        Identifier "layout"
        Option "AllowNVIDIAGPUScreens"
    EndSection

However, for me this has not worked. YMMV. It is possible that, in the future, a more minimal configuration will in fact work. It is suggested that this be monitored at this time. As is often the case with Xorg configuration, the less that is manually configured, and the more that is left to be auto-configured, the better.

Next, launch your xserver.

If GPU screen creation was successful, the log file /var/log/Xorg.0.log should contain lines with NVIDIA(G0), and querying the RandR providers with xrandr –listproviders should display a provider named NVIDIA-G0 (for “NVIDIA GPU screen 0”).

If that is the case, the following command:

    $ __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxinfo |grep 'OpenGL vendor'

should display:

OpenGL vendor string: NVIDIA Corporation

and the following command:

    $ glxinfo |grep 'OpenGL vendor'

should display your integrated GPU's vendor as opposed to NVIDIA (e.g., Intel).

You can then test using something like:

    $ __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxgears

You can now launch any program using your Nvidia dGPU by utilizing those two environment variables and prepending them to the program command you are running. I would refrain from using the GUI tools that come with nvidia-driver. I have no idea to what extent they will trample all over your /etc/ directory, and I have no idea if they actually work to get the above working, as this setup is still fairly bleeding-edge at this point.

As per usual, YMMV.
