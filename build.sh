#!/bin/bash

VERSION="v2.0"
KERNEL_SRC="/home/iceandfire/apocalypse/samsung-kernel-crespo"

export ARCH=arm
export LOCALVERSION="-Apoc-Talon-v2-NS"
export CROSS_COMPILE="/home/iceandfire/android-toolchain-eabi/bin/arm-eabi-"


cd $KERNEL_SRC

START=$(date +%s)

if [ -e ./releasetools/system/modules ]; then
 rm -rf ./releasetools/system/modules
fi

mkdir -p ./releasetools/system/modules

export INSTALL_MOD_PATH=./mod_inst
make modules -j`grep 'processor' /proc/cpuinfo | wc -l`
make modules_install

for i in `find mod_inst -name "*.ko"`; do
 cp $i ./releasetools/system/modules/
done

rm -rf ./mod_inst

make -j`grep 'processor' /proc/cpuinfo | wc -l`
cp $KERNEL_SRC/arch/arm/boot/zImage $KERNEL_SRC/releasetools/kernel/
cd $KERNEL_SRC/releasetools
rm -f *.zip
zip -r Apocalypse-TalonNS-$VERSION.zip *
rm $KERNEL_SRC/releasetools/kernel/zImage

cd $KERNEL_SRC

END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC
echo "Finished."
