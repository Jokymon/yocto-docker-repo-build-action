#!/bin/bash
set -e

# Make this script capable of handling GitHub actions as well as the
# VOLUME declared in the Dockerfile for local tests independent of the
# GitHub environment
if [ "x$GITHUB_WORKSPACE" = "x" ]; then
  cd /yocto_root
else
  echo "Detected GITHUB_WORKSPACE, changing directory"
  cd $GITHUB_WORKSPACE
fi

echo "Executing 'repo init -u . -m manifest.xml'"
repo init -u . -m manifest.xml
echo "Executing 'repo sync'"
repo sync

if [ "x$INPUT_BITBAKE_ARGS" = "x" ]; then
  INPUT_BITBAKE_ARGS="core-image-minimal"
fi

echo "Setting up the Poky environment"
source sources/poky/oe-init-build-env

# Unfortunately GitHub actions insist on running as 'root' user. Due to that we
# have to force Yocto to accept 'root' for building
pushd ../sources/poky
patch -p1 < /disable_root_user_check.patch
popd

echo "Running command 'bitbake $INPUT_BITBAKE_ARGS'"
bitbake $INPUT_BITBAKE_ARGS
