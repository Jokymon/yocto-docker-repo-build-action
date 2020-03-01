#!/bin/bash
set -e

# Make this script capable of handling GitHub actions as well as the
# VOLUME declared in the Dockerfile for local tests independent of the
# GitHub environment
if [ "x$GITHUB_WORKSPACE" = "x" ]; then
  mkdir /yocto_root
  cd /yocto_root
fi

repo init -u . -m manifest.xml
repo sync

if [ "x$INPUT_BITBAKE_ARGS" = "x" ]; then
  INPUT_BITBAKE_ARGS="core-image-minimal"
fi

echo "Setting up the Poky environment"
source sources/poky/oe-init-build-env

echo "Running command 'bitbake $INPUT_BITBAKE_ARGS'"
bitbake $INPUT_BITBAKE_ARGS
