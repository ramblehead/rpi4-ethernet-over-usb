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
  CMD=(cp -vf /etc/dhcpcd.conf /etc/dhcpcd.conf.setup-dnsmasq-bkp)
  echo + "${CMD[*]}" && "${CMD[@]}"

  echo
  CMD=('echo -e "\ndenyinterfaces usb0" >> /etc/dhcpcd.conf')
  echo + "${CMD[*]}" && eval "${CMD[*]}"
fi

# /b/}

# /b/; Install and configure dnsmasq - DHCP server for Ethernet over USB
# /b/{

echo
CMD=(apt update)
echo + "${CMD[*]}" && "${CMD[@]}"

echo
CMD=(apt install dnsmasq)
echo + "${CMD[*]}" && "${CMD[@]}"

echo
echo Creating /etc/dnsmasq.d/usb...
cat > /etc/dnsmasq.d/usb <<EOF
interface=usb0
dhcp-range=10.55.0.2,10.55.0.6,255.255.255.248,1h
dhcp-option=3,10.55.0.1
leasefile-ro
EOF

echo
echo Creating /etc/network/interfaces.d/usb0...
cat > /etc/network/interfaces.d/usb0 <<EOF
auto usb0
allow-hotplug usb0
iface usb0 inet static
  address 10.55.0.1
  netmask 255.255.255.248
EOF

# /b/}
