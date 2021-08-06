#!/bin/bash

wget -q 'https://www.memtest86.com/downloads/memtest86-usb.zip'
sha512sum memtest86-usb.zip
unzip -q memtest86-usb.zip

# ==============================================================================
# Note: How to get the offset in the mount command
# run this command: fdisk -lu memtest86-usb.img
# ------------------------------------Output-------------------------------------
# Disk memtest86-usb.img: 500 MiB, 524288000 bytes, 1024000 sectors
# Units: sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 512 bytes
# I/O size (minimum/optimal): 512 bytes / 512 bytes
# Disklabel type: gpt
# Disk identifier: 68264C0F-858A-49F0-B692-195B64BE4DD7
# Device              Start     End Sectors  Size Type
# memtest86-usb.img1   2048  512000  509953  249M Microsoft basic data
# memtest86-usb.img2 514048 1023966  509919  249M EFI System
# -----------------------------------End Output-----------------------------------
#
# In the last line we can see that EFI System has start offset of 514048
# But this is in Sectors not Bytes, We can see that Sector = 512
# i.e. offset = 514048*512 = 263192576
# ==============================================================================


sudo mkdir -p /mnt/memtest
sudo mount -o loop,offset=263192576 memtest86-usb.img /mnt/memtest/
mkdir memtest_efi
sudo cp -r /mnt/memtest/EFI/BOOT/* ./memtest_efi
sudo umount /mnt/memtest/

ls -lhR ./memtest_efi/
cd memtest_efi
sudo sha512sum * > checksum.sha512
cd ..

zip -q memtest86_efi.zip memtest_efi/*
sha512sum memtest86_efi.zip > memtest86_efi.zip.sha512
