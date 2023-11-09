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

sed -i "s:1.69.0:1.70.0:g" toolchain/android_rust/paths.py

cd prebuilts/rust/linux-x86
mkdir 1.70.0
cd 1.70.0
curl https://ftp.travitia.xyz/clang/rust-1-70-0.tar.xz | tar -xJ

cd /build/rust-toolchain/toolchain/android_rust
git am -3 /build/0001-Fix-directory-creation.patch
cd /build/rust-toolchain

./toolchain/android_rust/fetch_source.py 1.71.0 --beta

cp /build/rustc-0023-Add-Trusty-OS-support-to-Rust-std.patch toolchain/android_rust/patches/development/
cp /build/rustc-0022-PGO-staging.patch toolchain/android_rust/patches/development/
cp /build/rustc-0033-add-trusty-to-well-known-values-test.patch toolchain/android_rust/patches/development/
rm toolchain/android_rust/patches/upstreamed/rustc-0039-cc-rs-workaround.patch
rm toolchain/android_rust/patches/development/rustc-0038-Add-GNU-Property-Note.patch
rm toolchain/android_rust/patches/upstreamed/rustc-0040-Auto-merge-of-2935-bossmc-alias-lfs64-symbols-on-mus.patch
rm toolchain/android_rust/patches/upstreamed/rustc-0041-Auto-merge-of-3265-bossmc-issue-3264-variadic-open-a.patch

./toolchain/android_rust/build.py --lto thin --gc-sections --llvm-linkage shared

cd out/package
XZ_OPT="-9 -T0" tar cJf rust.tar.xz .

# Installable build is at /build/rust-toolchain/out/package/rust.tar.xz
