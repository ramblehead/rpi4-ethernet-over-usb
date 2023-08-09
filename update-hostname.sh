#!/bin/bash

set -eu
set -o pipefail

readonly ETHER=eth0
SNAME=$(basename "${BASH_SOURCE[0]}")
readonly SNAME

if [[ ${1:--} == '--help' ]]; then
  echo Usage: "${SNAME} [new-hostname]"
  echo If hostname is not provided, it will be generated
  echo using "${ETHER}" Ethernet MAC address.
  exit 1
fi

if [[ -z ${1:+-} ]]; then
  # Extract last six letters of ${ETHER} MAC address
  CMD=(ip addr '|')
  CMD+=(grep -Pzo "'${ETHER}.+\n.+'" '|')
  CMD+=(sed -n 2p '|')
  CMD+=(sed "'s/.*ether \+..:..:..:\(..\):\(..\):\(..\).*/\1\2\3/'")
  NEW_HOSTNAME=$(eval "${CMD[*]}")
  readonly NEW_HOSTNAME=rpi-${NEW_HOSTNAME}
else
  readonly NEW_HOSTNAME=$1
fi

CUR_HOSTNAME=$(cat '/etc/hostname')
readonly CUR_HOSTNAME
readonly ETC_HOSTNAME="/etc/hostname"
readonly ETC_HOSTS="/etc/hosts"

echo
CMD=(sed -i -E)
CMD+=("s/${CUR_HOSTNAME}/${NEW_HOSTNAME}/")
CMD+=("${ETC_HOSTNAME}")
echo + "${CMD[*]}" && eval "${CMD[*]}"

echo
CMD=(sed -i -E)
CMD+=("s/${CUR_HOSTNAME}/${NEW_HOSTNAME}/")
CMD+=("${ETC_HOSTS}")
echo + "${CMD[*]}" && eval "${CMD[*]}"
