#!/bin/bash

set -e

sudo_cmd=""
platform=$(uname -s)

case $platform in
  'Linux')
    [ $(id -u) -ne 0 ] && sudo_cmd="sudo"

    ${sudo_cmd} apt-get update
    ${sudo_cmd} apt-get install -y \
      pkg-config \
      libconfig-dev
    ;;
  'Darwin')
    brew update
    brew install -y \
      pkgconf \
      libconfig
    ;;
  *)
    echo "unsupported platform: '$platform'" >&2
    exit 1
    ;;
esac

echo -e "\033[97;42m============Setup Successful============\033[0m"
