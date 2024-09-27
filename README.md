# archinstall-personal

# Customized Arch Linux Installation Script

This repository contains a script for installing Arch Linux with BTRFS, encryption, and the Xfce desktop environment. The script is customized for a specific user setup but can be modified as needed.

## ⚠️ Security Warning

This script uses environment variables for sensitive information. Never hardcode passwords or sensitive data directly in the script or commit them to the repository.

## Prerequisites

- Arch Linux live environment
- Internet connection
- Basic knowledge of Linux and disk partitioning

## Usage

1. Boot into the Arch Linux live environment.
      
2. Connect to the internet.

3. Clone this repository:
   ```
   git clone https://github.com/Snowiseverything/archinstall-personal/
   cd archinstall-personal
   ```

4. Make the script executable:
   ```
   chmod +x arch_install.sh
   ```

5. Set the required environment variables:
   ```
   export USERNAME="uname"
   export HOSTNAME="hname"
   export ROOT_PASSWORD="your_root_password"
   export LUKS_PASSWORD="your_encryption_password"
   ```

6. Review and modify the script if necessary, especially the `DRIVE` variable to match your target drive.

7. Run the script:
   ```
   ./arch_install.sh
   ```

## Customization

- Modify the script to change partition sizes, packages, or other configurations as needed.
- The script currently installs Xfce. You can change this to another desktop environment or window manager for a more minimal setup.

## Recommendations for a Minimal Linux Installation

1. **Choose lightweight software:**
   - Consider using a lightweight window manager like i3, bspwm, or dwm instead of Xfce.
   - Use lightweight alternatives to common applications (e.g., pcmanfm instead of nautilus for file management).

2. **Minimize installed packages:**
   - Only install what you need. You can always add more later.
   - Consider using the `base` package instead of `base-devel` if you don't need development tools.

3. **Use lightweight system services:**
   - Consider alternatives like elogind instead of systemd for session management.
   - Use lightweight alternatives for other system services where possible.

4. **Optimize your kernel:**
   - Use a custom kernel configuration to remove unnecessary modules and features.

5. **Utilize BTRFS features:**
   - Use BTRFS compression to save disk space.
   - Leverage BTRFS snapshots for system backups and easy rollbacks.

6. **Implement a robust update strategy:**
   - Regularly update your system, but be cautious with rolling releases.
   - Use BTRFS snapshots before major updates to easily roll back if needed.

7. **Security considerations:**
   - Implement a firewall (e.g., ufw or iptables).
   - Use strong passwords and consider two-factor authentication where possible.
   - Regularly audit your installed packages and remove unnecessary ones.

## Additional Notes

- This script sets up full disk encryption for improved security.
- The BTRFS filesystem allows for easy snapshots and more flexible storage management.
- Modify the timezone in the script from UTC to your local timezone if needed.
- After installation, change all passwords to strong, unique passwords.

## Contributing

This is a personal script, but suggestions for improvements are welcome. Please open an issue to discuss potential changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

Use this script at your own risk. Always backup your data before performing system installations or modifications.
