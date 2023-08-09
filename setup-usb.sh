#!/bin/bash

set -eu
set -o pipefail

if (( $(id -u) != 0 )); then
  echo "Please, run as root"
  exit 1
fi

# /b/; Update /boot/config.txt with dwc2
# /b/{

if ! grep -qE '^\s*dtoverlay\s*=\s*dwc2\s*$' /boot/config.txt
then
  CMD=(cp -vf /boot/config.txt /boot/config.txt.setup-usb-bkp)
  echo + "${CMD[*]}" && "${CMD[@]}"

  CMD=('echo "dtoverlay=dwc2" >> /boot/config.txt')
  echo + "${CMD[*]}" && eval "${CMD[*]}"
fi

# /b/}

# /b/; Update /boot/cmdline.txt with dwc2
# /b/{

if ! grep -qE 'modules-load=dwc2' /boot/cmdline.txt
then
  echo
  CMD=(cp -f /boot/cmdline.txt /boot/cmdline.txt.setup-usb-bkp)
  echo + "${CMD[*]}" && "${CMD[@]}"

  CMD=(sed -i -E)
  CMD+=("'s/^\(.*\s+rootwait\)\s+\(.*\)$/\1 modules-load=dwc2 \2/'")
  echo + "${CMD[*]}" && eval "${CMD[*]}"
fi

# /b/}

# /b/; Enable ssh
# /b/{

CMD=(touch ssh)
echo + "${CMD[*]}" && "${CMD[@]}"

# /b/}

# /b/; Enable libcomposite module
# /b/{

if ! grep -qE 'libcomposite' /etc/modules
then
  CMD=(cp -vf /etc/modules /etc/modules.setup-usb-bkp)
  echo + "${CMD[*]}" && "${CMD[@]}"

  CMD=('echo "libcomposite" >> /etc/modules')
  echo + "${CMD[*]}" && eval "${CMD[*]}"
fi

# /b/}
