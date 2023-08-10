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

# /b/; Teardown systemd script that sets up USB Device Descriptor
# /b/{

echo
CMD=('systemctl disable rpi4-usb.service ||:')
echo + "${CMD[*]}" && eval "${CMD[*]}"

readonly STOW_NAME=rpi4-ethernet-over-usb

if [[ -d /usr/local/stow/${STOW_NAME} ]]
then
  echo
  cd /usr/local/stow; echo + cd "${PWD}"

  echo
  CMD=(stow -vD "${STOW_NAME}")
  echo + "${CMD[*]}" && "${CMD[@]}"

  echo
  CMD=(rm -rvf "${STOW_NAME}")
  echo + "${CMD[*]}" && "${CMD[@]}"
else
  echo
  CMD=(rm -vf /usr/local/bin/rpi4-usb.sh)
  echo + "${CMD[*]}" && "${CMD[@]}"

  CMD=(rm -vf /usr/local/lib/systemd/system/rpi4-usb.service)
  echo + "${CMD[*]}" && "${CMD[@]}"
fi

# /b/}

# /b/; Disable libcomposite module
# /b/{

if grep -qE '^\s*libcomposite\s*$' /etc/modules
then
  echo
  CMD=(cp -vf /etc/modules /etc/modules.teardown-usb-bkp)
  echo + "${CMD[*]}" && "${CMD[@]}"

  echo
  CMD=(sed -zE -i)
  CMD+=("'s/[^\n]*libcomposite\s*\n//g'")
  CMD+=(/etc/modules)
  echo + "${CMD[*]}" && eval "${CMD[*]}"
fi

# /b/}

# /b/; Remove dwc2 from /boot/cmdline.txt
# /b/{

if grep -qE 'modules-load=dwc2' /boot/cmdline.txt
then
  echo
  CMD=(cp -f /boot/cmdline.txt /boot/cmdline.txt.setup-usb-bkp)
  echo + "${CMD[*]}" && "${CMD[@]}"

  echo
  CMD=(sed -E -i)
  CMD+=("'s/\s+modules-load=dwc2\s+/ /'")
  CMD+=(/boot/cmdline.txt)
  echo + "${CMD[*]}" && eval "${CMD[*]}"
fi

# /b/}

# /b/; Remove dwc2 from /boot/config.txt
# /b/{

if grep -qE '^\s*dtoverlay\s*=\s*dwc2\s*$' /boot/config.txt
then
  echo
  CMD=(cp -vf /boot/config.txt /boot/config.txt.teardown-usb-bkp)
  echo + "${CMD[*]}" && "${CMD[@]}"

  echo
  CMD=(sed -zE -i)
  CMD+=("'s/[^\n]*dtoverlay\s*=\s*dwc2\s*\n//g'")
  CMD+=(/boot/config.txt)
  echo + "${CMD[*]}" && eval "${CMD[*]}"
fi

# /b/}
