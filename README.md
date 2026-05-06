# archinstall-personal

<p align="center">
  <a href="https://github.com/Snowiseverything/archinstall-personal/stargazers"><img src="https://shieldcn.dev/github/stars/Snowiseverything/archinstall-personal.svg" alt="stars" /></a>
  <a href="https://github.com/Snowiseverything/archinstall-personal/fork"><img src="https://shieldcn.dev/github/forks/Snowiseverything/archinstall-personal.svg" alt="forks" /></a>
  <a href="https://github.com/Snowiseverything/archinstall-personal/blob/main/LICENSE"><img src="https://shieldcn.dev/badge/license-GPL--3.0-blue.svg" alt="license" /></a>
  <a href="https://github.com/Snowiseverything/archinstall-personal/commits"><img src="https://shieldcn.dev/github/last-commit/Snowiseverything/archinstall-personal.svg" alt="last commit" /></a>
</p>

```
        .-.
       (   )
        '-'
   Arch Linux Installer
```

## Features

| Feature | Description |
|---------|-------------|
| **BTRFS** | Subvolumes for `@`, `@home`, `@swap` with zstd compression |
| **LUKS** | Full disk encryption (LVM on LUKS) |
| **Xfce** | Lightweight desktop with LightDM |
| **GRUB** | EFI bootloader with encryption support |
| **NetworkManager** | Out-of-the-box networking |

## Quick Start

```bash
git clone https://github.com/Snowiseverything/archinstall-personal/
cd archinstall-personal
chmod +x arch_install.sh

# Set environment variables (DO NOT hardcode)
export USERNAME="youruser"
export HOSTNAME="yourhostname"
export ROOT_PASSWORD="yourpassword"
export LUKS_PASSWORD="yourpassword"

# Edit DRIVE in script (e.g., /dev/sda)
$EDITOR arch_install.sh

# Run
./arch_install.sh
```

## Requirements

- Arch Linux live environment (ISO)
- UEFI firmware
- Internet connection
- Target drive (will be wiped)

Find your target drive with:
```bash
lsblk -d -o NAME,SIZE,TYPE,MODEL
```

## What Gets Installed

- Base system + linux + linux-firmware
- Xfce4 + xorg + LightDM
- NetworkManager
- GRUB bootloader
- Your user with sudo access

## Customization

Edit these variables in the script before running:

```bash
DRIVE="/dev/sdX"      # Target drive
BOOT_SIZE="512MiB"    # Boot partition size
SWAP_SIZE="16GiB"     # Swap size
ROOT_SIZE="50GiB"     # Root partition size
```

Change timezone in the script at:
```bash
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
```

## License

GPL v3.0 - See [LICENSE](LICENSE)

## Disclaimer

Use at your own risk. Always back up important data.