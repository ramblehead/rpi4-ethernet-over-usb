# Raspberry Pi 4 Ethernet-over-USB

A set of automated scripts to install and configure local Ethernet-over-USB on
Raspberry Pi 4.

**These scripts are intended to run on Raspberry Pi 4 with Raspberry Pi
OS. Running it on other systems might have unintended consequences.**

# Install

Copy the content of this repository to your Raspberry Pi home directory using
one of the available methods.

For example, with `git`:

```bash
cd
git clone https://github.com/ramblehead/rpi4-ethernet-over-usb.git
cd rpi4-ethernet-over-usb
```

To install Ethernet-over-USB run:
 ```bash
 sudo ./setup-usb.sh
 ```

To install and configure local DHCP server on Raspberry Pi run:
 ```bash
 sudo ./setup-dnsmasq.sh
 ```

Restart Raspberry Pi two times:
 ```bash
 sudo reboot
 ```

# Default network configuration

After performing installation steps, it should become possible to connect
Raspberry Pi USB-C port (the port used for power) to any computer running modern
OS as Ethernet-over-USB gadget.

This configuration has been tested on Windows 10, Windows 11 and Ubuntu 22.04
LTS. It should also work on any system that supports either RNDIS or CDC-ECM USB
protocols.

## Default IP address

Default IP address set by `setup-dnsmasq.sh` script is:

```
10.55.0.1
```

this IP address can be used to access Raspberry Pi from the host computer. For example:

```bash
ssh <user-name>@10.55.0.1
```

where `<user-name>` is your user name on Raspberry Pi.


## mDNS

mDNS stands for "Multicast DNS". It is a protocol that allows devices on a local
network to discover and communicate with each other using domain names without
requiring a centralized DNS server.

On Raspberry Pi mDNS is configured by default (with `avahi`). `avahi` uses
Raspberry Pi OS `<hostname>` as the default mDNS name.

By convention mDNS names are distinguished by `.local` domain. For example, if
your Raspberry Pi OS `<hostname>` is `rh-rpi`, then mDNS address should be:

```
rh-rpi.local
```

making it possible to access Raspberry Pi by this address. For example:

```bash
ssh <user-name>@rh-rpi.local
```

where `<user-name>` is your Raspberry Pi OS user name.

## Hostname

To quickly change Raspberry Pi OS hostname, provided `update-hostname.sh` script
could be used.

Running `update-hostname.sh` script with no arguments automatically generates
host name using physical Ethernet adapter MAC address with the following
pattern:

```bash
rpi-aabbcc
```

where `aa`, `bb` and `cc` are the last three hex digits of the MAC address.

First argument of `update-hostname.sh` is the user-defined `<hostname>`. For
example, to set `<hostname>` to `rh-rpi` run:

```bash
sudo ./update-hostname.sh rh-rpi
```

# Credits

* David Lechner's project:
  https://github.com/ev3dev/ev3-systemd/blob/ev3dev-jessie/scripts/ev3-usb.sh

* Ben Hardill's blog post:
  https://www.hardill.me.uk/wordpress/2019/11/02/pi4-usb-c-gadget/
