[![Build Status](https://travis-ci.org/fetzerch/hp-n54l-drivers.svg?branch=master)](https://travis-ci.org/fetzerch/hp-n54l-drivers)

# Unofficial Linux drivers for HP ProLiant MicroServer G7 N54L

This repository contains unofficial Linux drivers for the HP ProLiant
Microserver G7 N54L.

## Drivers

### I2C Driver for accessing voltage, temperature and fan values

The project contains a backport of the *i2c_piix4* kernel module from
Linux 4.5 that allows one to access the Winbond W83795ADG in order to read
sensor values with lm-sensors. The module is confirmed to work with Kernel
3.13 onwards.

After installation of the DKMS module, issue the following commands to reload
the respective modules:

    # rmmod sp5100_tco
    # rmmod w83795 jc42 i2c_piix4
    # modprobe -a i2c_piix4 jc42 w83795

The sensors values can now be accessed using the `sensors` command.

When manually installed, the file `config/modules-load.d/hp-n54l.conf` has to
be copied to `/etc/modules-load.d/hp-n54l.conf` in order to automatically load
the modules after reboot.

The file `config/sensors.d/hp-n54l.conf` configures limits and label names for
`sensors`. Issue `# sensors -s` to reload the file after copying it to
`/etc/sensors.d/hp-n54l.conf`.

The [i2c-piix4 module conflicts with the onboard watchdog](
http://www.spinics.net/lists/linux-i2c/msg23437.html). Therefore it has to be
ensured that `sp5100_tco` is unloaded before loading `i2c_piix4`. The module
should be blacklisted to it from being loaded automatically. This can be
achieved by copying the file `config/modprobe.d/blacklist-n54l-watchdog.conf`
to `/etc/modprobe.d/blacklist-n54l-watchdog.conf`.

## Installation

The modified drivers can be built and installed using DKMS either
manually or through the included Debian package.

### Manual installation with DKMS

DKMS (Dynamic Kernel Module Support) enables generating Linux kernel modules
outside the kernel source tree. It rebuilds the modules automatically
when a new kernel is installed.

The content of this repository has to be copied to
`/usr/src/hp-n54l-<VERSION>`. The following commands install the DKMS
module:

    # dkms add -m hp-n54l -v <VERSION>
    # dkms build -m hp-n54l -v <VERSION>
    # dkms install -m hp-n54l -v <VERSION>

To remove the module:

    # dkms remove -m hp-n54l -v <VERSION>

### Installation of the Debian package

On Debian based distributions `debuild -us -uc` can be used to package
the drivers into a `hp-n54l-dkms\*_all.deb` file which can be installed
using `dpkg -i`.

On Ubuntu the drivers can be installed from the following [Personal Package
Archive (PPA)](https://launchpad.net/~fetzer-ch/+archive/ubuntu/hp-n54l)

## License

Packaging and patches copyright 2015 Christian Fetzer. Kernel modules are part
or Linux. Linux is copyrighted by Linus Torvalds and others.
This project is licensed under the terms of the GNU General Public License
(GPL-2+).
