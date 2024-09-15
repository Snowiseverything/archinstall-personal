#!/bin/bash

# Exit on any error
set -e

# Use environment variables for sensitive information
# DO NOT set these variables in the script file
# Set them in your shell before running the script:
# export USERNAME="snow"
# export HOSTNAME="freezer"
# export ROOT_PASSWORD="Sn0wmann"
# export LUKS_PASSWORD="12021$mptW12021"

# Ensure required environment variables are set
if [ -z "$USERNAME" ] || [ -z "$HOSTNAME" ] || [ -z "$ROOT_PASSWORD" ] || [ -z "$LUKS_PASSWORD" ]; then
    echo "Error: Required environment variables are not set."
    echo "Please set USERNAME, HOSTNAME, ROOT_PASSWORD, and LUKS_PASSWORD before running this script."
    exit 1
fi

# Replace with your drive
DRIVE="/dev/sdX"

# Partition sizes
BOOT_SIZE="512MiB"
SWAP_SIZE="16GiB"
ROOT_SIZE="50GiB"
# Home will use the remaining space

echo "This script will erase all data on $DRIVE. Are you sure you want to continue? (y/N)"
read -r confirm
if [[ $confirm != "y" && $confirm != "Y" ]]; then
    echo "Installation cancelled."
    exit 1
fi

# Partition the drive
parted -s "$DRIVE" \
    mklabel gpt \
    mkpart primary fat32 1MiB $BOOT_SIZE \
    set 1 esp on \
    mkpart primary $BOOT_SIZE 100%

# Set up encryption
echo -n "$LUKS_PASSWORD" | cryptsetup luksFormat "${DRIVE}2" -
echo -n "$LUKS_PASSWORD" | cryptsetup open "${DRIVE}2" cryptlvm -

# Create BTRFS filesystem
mkfs.btrfs /dev/mapper/cryptlvm
mount /dev/mapper/cryptlvm /mnt

# Create subvolumes
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@swap

# Mount subvolumes
umount /mnt
mount -o subvol=@,compress=zstd /dev/mapper/cryptlvm /mnt
mkdir /mnt/home
mount -o subvol=@home,compress=zstd /dev/mapper/cryptlvm /mnt/home
mkdir /mnt/swap
mount -o subvol=@swap /dev/mapper/cryptlvm /mnt/swap

# Create and mount boot partition
mkdir /mnt/boot
mkfs.fat -F32 "${DRIVE}1"
mount "${DRIVE}1" /mnt/boot

# Create swap file
btrfs filesystem mkswapfile --size $SWAP_SIZE /mnt/swap/swapfile
swapon /mnt/swap/swapfile

# Install base system
pacstrap /mnt base base-devel linux linux-firmware

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot and configure system
arch-chroot /mnt /bin/bash <<EOF
# Set timezone (change to your timezone)
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

# Set locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set hostname
echo "$HOSTNAME" > /etc/hostname

# Set root password
echo "root:$ROOT_PASSWORD" | chpasswd

# Install and configure bootloader
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=$(blkid -s UUID -o value ${DRIVE}2):cryptlvm root=\/dev\/mapper\/cryptlvm"/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Configure mkinitcpio for encryption
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Install Xfce and display manager
pacman -S --noconfirm xorg xfce4 xfce4-goodies lightdm lightdm-gtk-greeter networkmanager

# Enable services
systemctl enable lightdm
systemctl enable NetworkManager

# Create a user
useradd -m -G wheel -s /bin/bash "$USERNAME"
echo "$USERNAME:$ROOT_PASSWORD" | chpasswd

# Configure sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

EOF

echo "Installation complete! You can now reboot into your new Arch Linux system."
