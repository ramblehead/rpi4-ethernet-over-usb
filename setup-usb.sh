#!/bin/bash

set -eu
set -o pipefail

if (( $(id -u) != 0 )); then
  echo "Please, run as root"
  exit 1
fi

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
SDPATH="$(cd "${SDPATH}" && pwd)"
readonly SDPATH

cd "${SDPATH}"; echo + cd "${PWD}"

# /b/; Update /boot/config.txt with dwc2
# /b/{

if ! grep -qE '^\s*dtoverlay\s*=\s*dwc2\s*$' /boot/config.txt
then
  echo
  CMD=(cp -vf /boot/config.txt /boot/config.txt.setup-usb-bkp)
  echo + "${CMD[*]}" && "${CMD[@]}"

  echo
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

  CMD=(sed -E -i)
  CMD+=('"s/^(.*\s+rootwait)\s+(.*)$/\1 modules-load=dwc2 \2/"')
  CMD+=(/boot/cmdline.txt)
  echo + "${CMD[*]}" && eval "${CMD[*]}"
fi

# /b/}

# /b/; Enable ssh
# /b/{

echo
CMD=(touch /boot/ssh)
echo + "${CMD[*]}" && "${CMD[@]}"

# /b/}

# /b/; Enable libcomposite module
# /b/{

if ! grep -qE '^\s*libcomposite\s*$' /etc/modules
then
  echo
  CMD=(cp -vf /etc/modules /etc/modules.setup-usb-bkp)
  echo + "${CMD[*]}" && "${CMD[@]}"

  CMD=('echo "libcomposite" >> /etc/modules')
  echo + "${CMD[*]}" && eval "${CMD[*]}"
fi

# /b/}

# /b/; Configure systemd script that sets up USB Device Descriptor
# /b/{

if [[ -d /usr/local/stow ]]
then
  readonly STOW_NAME=rpi4-ethernet-over-usb

  echo
  CMD=(mkdir -p "/usr/local/stow/${STOW_NAME}")
  echo + "${CMD[*]}" && "${CMD[@]}"

  CMD=(cp -rvf root/* "/usr/local/stow/${STOW_NAME}")
  echo + "${CMD[*]}" && "${CMD[@]}"

  echo
  cd /usr/local/stow; echo + cd "${PWD}"

  echo
  CMD=(stow -v "${STOW_NAME}")
  echo + "${CMD[*]}" && "${CMD[@]}"
else
  echo
  CMD=(cp -rvf root/* /usr/local)
  echo + "${CMD[*]}" && "${CMD[@]}"
fi

echo
CMD=(systemctl enable rpi4-usb.service)
echo + "${CMD[*]}" && "${CMD[@]}"

# /b/}
