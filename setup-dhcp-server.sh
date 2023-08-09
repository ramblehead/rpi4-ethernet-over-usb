#!/bin/bash

set -eu
set -o pipefail

if (( $(id -u) != 0 )); then
  echo "Please, run as root"
  exit 1
fi

# /b/; Disable DHCP client for Ethernet over USB
# /b/{

if ! grep -qE '^\s*denyinterfaces\s*usb0\s*$' /etc/dhcpcd.conf
then
  CMD=(cp -vf /etc/dhcpcd.conf /etc/dhcpcd.conf.bkp)
  echo + "${CMD[*]}" && "${CMD[@]}"

  CMD=('echo -e "\ndenyinterfaces usb0" >> /boot/config.txt')
  echo + "${CMD[*]}" && eval "${CMD[*]}"
fi

# /b/}
