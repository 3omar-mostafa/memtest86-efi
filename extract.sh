#!/bin/bash
set -e -o pipefail

wget -q 'https://www.memtest86.com/downloads/memtest86-usb.zip'
sha512sum memtest86-usb.zip
unzip -q memtest86-usb.zip

# ==============================================================================
# Note: How to get the offset in the mount command
# run this command: fdisk -lu memtest86-usb.img
# ------------------------------------Output-------------------------------------
# Disk memtest86-usb.img: 1 GiB, 1073741824 bytes, 2097152 sectors
# Units: sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 512 bytes
# I/O size (minimum/optimal): 512 bytes / 512 bytes
# Disklabel type: gpt
# Disk identifier: 9A82C153-9542-42F5-8883-CF351C5DE568

# Device               Start     End Sectors  Size Type
# memtest86-usb.img1    2048  524287  522240  255M Microsoft basic data
# memtest86-usb.img2  524288 1048575  524288  256M EFI System
# memtest86-usb.img3 1048576 2097118 1048543  512M Microsoft basic data
# -----------------------------------End Output-----------------------------------
#
# In the output we can see that EFI System has start offset of 524288
# But this is in Sectors not Bytes, We can see that Sector = 512
# i.e. offset = 524288 * 512 = 268435456
# ==============================================================================

# In version 9, offset was 263192576
# In version 10, offset is 268435456
# We calculate it dynamically in case it changed
sector_offset=$(fdisk -lu memtest86-usb.img | grep EFI | tr -s ' ' | cut -d' ' -f2)
SECTOR_SIZE=512
offset=$(( SECTOR_SIZE * sector_offset ))

mkdir -p /mnt/memtest
mount -o loop,offset=${offset} memtest86-usb.img /mnt/memtest/
mkdir memtest_efi
cp -r /mnt/memtest/EFI/BOOT/* ./memtest_efi
umount /mnt/memtest/

ls -lhR ./memtest_efi/
cd memtest_efi
sha512sum * > checksum.sha512 || true
cd ..

zip -q memtest86_efi.zip memtest_efi/*
sha512sum memtest86_efi.zip > memtest86_efi.zip.sha512
