#!/bin/bash

set -eu
set -o pipefail

if (( $(id -u) != 0 )); then
  echo "Please, run as root"
  exit 1
fi

# /b/; Remove dnsmasq DHCP server configuration for for Ethernet over USB
# /b/{

echo
CMD=(rm -vf /etc/dnsmasq.d/usb)
echo + "${CMD[*]}" && "${CMD[@]}"

echo
CMD=(rm -vf /etc/network/interfaces.d/usb0)
echo + "${CMD[*]}" && "${CMD[@]}"

# /b/}

# /b/; Disable DHCP client for Ethernet over USB
# /b/{

if grep -qE '^\s*denyinterfaces\s*usb0\s*$' /etc/dhcpcd.conf
then
  echo
  CMD=(cp -vf /etc/dhcpcd.conf /etc/dhcpcd.conf.teardown-dnsmasq-bkp)
  echo + "${CMD[*]}" && "${CMD[@]}"

  echo
  CMD=(sed -zE -i)
  CMD+=("'s/[^\n]*denyinterfaces\s+usb0\s*\n//g'")
  CMD+=(/etc/dhcpcd.conf)
  echo + "${CMD[*]}" && eval "${CMD[*]}"

  echo
  CMD=(sed -E -i)
  CMD+=("':a;N;\$!ba;s/\n+$//'")
  CMD+=(/etc/dhcpcd.conf)
  echo + "${CMD[*]}" && eval "${CMD[*]}"
fi

# /b/}
