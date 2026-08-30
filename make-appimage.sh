#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q abaddon | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/uowuo/abaddon/refs/heads/master/res/desktop/icon.svg
export DESKTOP=/usr/share/applications/abaddon.desktop
export STARTUPWMCLASS=abaddon
export USE_HOST_DRIVERS_EXPERIMENTAL=1

# Deploy dependencies
quick-sharun /usr/bin/abaddon /usr/share/abaddon

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
