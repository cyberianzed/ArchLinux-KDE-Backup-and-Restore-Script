# Arch Linux KDE Backup & Restore Script

A full backup and restore solution for Arch Linux with KDE Plasma, designed to capture your exact system experience—configs, themes, fonts, packages, and more.

## Features

- Backup KDE settings, dotfiles, themes, and system configs
- Reinstall all packages (Pacman + AUR)
- Friendly, color-coded CLI scripts with confirmations
- Great for setting up new systems or fresh installs

## Structure

```
arch-linux-setup/
├── backup.sh # Interactive backup script
├── restore.sh # Safe restore script
├── backup.conf # List of dotfiles to back up
├── pkglist.txt # Saved list of pacman packages
├── aurpkglist.txt # Saved list of AUR packages
├── dotfiles/ # (Optional) manually tracked configs
├── themes/ # GTK/KDE themes and icons
├── fonts/ # Custom fonts
├── system/ # System config backups (e.g., GRUB, X11)
```

## Requirements

- Arch Linux
- KDE Plasma
- yay (or other AUR helper)
- git, cp, sudo, pacman

## Usage

### Backup

1. Clone this repo `https://github.com/cyberianzed/ArchLinux-KDE-Backup-and-Restore-Script.git`
2. Run `./backup.sh`
3. Your backup will be saved in `arch-backup/`

### Restore

1. Copy the folder on the new machine
2. Run `./restore.sh`
3. Reboot or log out/in

## Tips

- Reapply themes via KDE System Settings
- Run this if the panel or widgets look wrong `killall plasmashell && kstart5 plasmashell`


---

## ✅ Backup Coverage

| Component                   | Backup | Notes                                                      |
| --------------------------- | ---------------------------------- | ---------------------------------------------------------- |
| **User Dotfiles**           | ✅ via `backup.conf`                | `.bashrc`, `.zshrc`, `.xinitrc`, etc. included             |
| **KDE Settings**            | ✅ in `backup.conf`                 | Includes `plasmarc`, `kdeglobals`, `appletsrc`, etc.       |
| **Qt5/6 Configs**           | ✅ in `backup.conf`                 | Includes `qt5ct`, `qt6ct`                                  |
| **Themes & Icons**          | ✅ by script                        | Backs up both user and system themes/icons                 |
| **Fonts & Fontconfig**      | ✅ by script and `backup.conf`      | Includes `.fonts/`, `.local/share/fonts/`, and font config |
| **Wallpaper Images**        | ✅ via `backup.conf`                | Include path like `~/Pictures/wallpapers/`                 |
| **Autostart & Face Image**  | ✅ in `backup.conf`                 | KDE autostart apps, `.face`, etc.                          |
| **AUR + Pacman Packages**   | ✅ by script                        | Generates `pkglist.txt` and `aurpkglist.txt`               |
| **Display Manager Configs** | ✅ by script                        | Backs up `sddm.conf`, `lightdm`, etc.                      |
| **User Scripts & Binaries** | ✅ via `backup.conf`                | Includes `~/bin`, `~/.local/bin`                           |
| **GTK Configs**             | ✅ in `backup.conf`                 | Includes `gtk-3.0`, `gtk-4.0`                              |
| **XDG User Dirs**           | ✅ in `backup.conf`                 | `~/.config/user-dirs.dirs`                                 |
| **Shell Frameworks**        | ✅ in `backup.conf`                 | e.g. `~/.oh-my-zsh`, `~/.bash_it`                          |
| **KDE Konsole + Dolphin**   | ✅ in `backup.conf`                 | Includes `~/.config/konsole/`, `dolphinrc`, etc.           |
| **Cron jobs (if any)**      | 🚫 Optional                        | Can add `crontab -l > cron.txt` if needed                  |

---
