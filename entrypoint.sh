#!/bin/bash
set -e

cd /yocto_root
repo init -u . -m manifest.xml
repo sync

if [ "x$INPUT_BITBAKE_ARGS" = "x" ]; then
  INPUT_BITBAKE_ARGS="core-image-minimal"
fi

echo "Setting up the Poky environment"
source sources/poky/oe-init-build-env

echo "Running command 'bitbake $INPUT_BITBAKE_ARGS'"
bitbake $INPUT_BITBAKE_ARGS
