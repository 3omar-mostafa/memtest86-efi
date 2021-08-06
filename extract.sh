#!/bin/bash

wget -q 'https://www.memtest86.com/downloads/memtest86-usb.zip'
sha512sum memtest86-usb.zip
unzip -q memtest86-usb.zip

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
