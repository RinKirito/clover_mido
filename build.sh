#!/bin/bash
#
# Copyright © 2018, "penglezos" <panagiotisegl@gmail.com>
# Thanks to Vipul Jha for zip creator
# Android Kernel Compilation Script
#

tput reset
echo -e "==============================================="
echo    "         Compiling Clover Kernel             "
echo -e "==============================================="

LC_ALL=C date +%Y-%m-%d
date=`date +"%Y%m%d-%H%M"`
BUILD_START=$(date +"%s")
KERNEL_DIR=$PWD
REPACK_DIR=$KERNEL_DIR/zip
OUT=$KERNEL_DIR/out
ZIP_NAME="$VERSION"-"$DATE"
VERSION="v1.0~AeroSmith~"
DATE=`date +"%Y%m%d"`
export ARCH=arm64 && export SUBARCH=arm64
export CROSS_COMPILE="/home/Rin/linaro/bin/aarch64-linux-gnu-"

make_zip()
{
		cd $REPACK_DIR
		cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR/
		FINAL_ZIP="CloverKernel-${VERSION}-${DATE}.zip"
        zip -r9 "${FINAL_ZIP}" *
		cp *.zip $OUT
		rm *.zip
		cd $KERNEL_DIR
		rm zip/Image.gz-dtb
}

rm -rf out
mkdir -p out
make O=out clean
make O=out mrproper
make O=out franco_mido_defconfig
make O=out -j$(nproc --all)
make_zip

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
