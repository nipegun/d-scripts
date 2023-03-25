

install grub-efi-amd64

grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB
echo "configfile (hd0,gpt#)/boot/grub.cfg" > /boot/efi/EFI/debian/grub.cfg
