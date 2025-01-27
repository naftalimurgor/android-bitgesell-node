#!/usr/bin/env bash

# Bitgesell Core Release: https://github.com/BitgesellOfficial/bitgesell/releases/tag/0.1.13
BITGESELL_CORE=0.1.13

# Update git submodule to sync Bitgesell Core: https://github.com/BitgesellOfficial/bitgesell
git submodule update --init --recursive

# Build Android Source Docker image(https://github.com/BitgesellOfficial/bitgesell)
docker build -t naftalimurgor/android-bitgesell .

# Build Android Application Package (.apk) file for Android device
cd src/bitgesell/
git checkout $BITGESELL_CORE_VERSION

docker run --rm -v $(pwd):/work --user "$(id -u):$(id -g)" -i android-bitgesell /bin/bash
cd /work

make -C depends
./autogen.sh
./configure --host=${HOST} --prefix=/work/depends/${HOST} \
  --disable-bench \
  --disable-gui-tests \
  --disable-tests \
  --disable-wallet

make -j 8
make -C src/qt apk

# src/qt/android/build/outputs/apk/release/android-release-unsigned.apk
# src/qt/android/build/outputs/apk/debug/android-debug.apk
