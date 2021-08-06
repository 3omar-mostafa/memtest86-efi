# Memtest86 EFI Extract
Extract memtest86 EFI partition

[Memtest86](https://www.memtest86.com/memtest86.html) is well known memory (RAM) testing software

# Use Case
If you need to boot from memtest86 without burning it into a CD/Flash Drive you will need  to put memtest86 `EFI` files into your `EFI` System Partition and boot directly fom it, Here's when this repo comes in handy

It downloads the memtest86 image and extract `EFI` partition from it

# Download
You can find the extracted partitions at [Releases](https://github.com/3omar-mostafa/memtest86-efi/releases)

This repo use scheduled github action which runs every month to check for updates and release them

# Credits
I have used [this article](https://www.yosoygames.com.ar/wp/2020/03/installing-memtest86-on-uefi-grub2-ubuntu/) and others to get the offset of `EFI` partition
