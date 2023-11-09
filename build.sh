#!/usr/bin/bash

# /build is a tmpfs

THREAD_COUNT=$(nproc --all)

git config --global user.name "Leonardo Davinci"
git config --global user.email "not@existing.org"
git config --global color.ui true

cd /build
mkdir rust-toolchain
cd rust-toolchain
repo init -u https://android.googlesource.com/platform/manifest -b rust-toolchain
repo sync -c --jobs-network=$(( $THREAD_COUNT < 16 ? $THREAD_COUNT : 16)) -j$THREAD_COUNT --jobs-checkout=$THREAD_COUNT --no-clone-bundle --no-tags

#./toolchain/android_rust/fetch_source.py 1.70.0

cd /build/rust-toolchain
./toolchain/android_rust/build.py --lto thin --gc-sections --llvm-linkage shared

cd out/package
XZ_OPT="-9 -T0" tar cJf rust.tar.xz .

# Installable build is at /build/rust-toolchain/out/package/rust.tar.xz
