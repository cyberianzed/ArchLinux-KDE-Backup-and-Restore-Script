#!/bin/bash
set -euo pipefail

BACKUP_DIR="$(pwd)/arch-backup"
PKG_FILE="$BACKUP_DIR/pkglist.txt"
AUR_FILE="$BACKUP_DIR/aurpkglist.txt"
CONFIG_DIR="$BACKUP_DIR/configurations"
THEME_DIR="$BACKUP_DIR/themes"
FONT_DIR="$BACKUP_DIR/fonts"
SYSTEM_DIR="$BACKUP_DIR/system"

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m"

function info() { echo -e "${BLUE}[INFO]${NC} $1"; }
function success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
function warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
function error_exit() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

function confirm() {
    echo
    echo "This script will:"
    echo "1. Restore your dotfiles and application configs."
    echo "2. Reinstall packages from pacman and AUR."
    echo "3. Restore KDE themes, fonts, and customizations."
    echo "4. Overwrite files in your system directories (with sudo)."
    echo
    read -rp "$(echo -e "${YELLOW}Do you want to continue? (y/n): ${NC}")" confirm
    [[ $confirm =~ ^[Yy]$ ]] || { info "Restore cancelled."; exit 0; }
}

function check_requirements() {
    for cmd in pacman yay sudo; do
        if ! command -v "$cmd" &>/dev/null; then
            error_exit "Missing required command: $cmd"
        fi
    done
}

function restore_configs() {
    info "Restoring configurations..."
    cp -rv "$CONFIG_DIR"/. ~/
}

function restore_packages() {
    info "Restoring package list..."
    sudo pacman -S --needed - < "$PKG_FILE"
    yay -S --needed - < "$AUR_FILE" || warn "Some AUR packages may have failed to install."
}

function restore_themes_and_fonts() {
    info "Restoring themes and fonts..."
    mkdir -p ~/.themes ~/.icons ~/.fonts ~/.local/share/fonts
    cp -r "$THEME_DIR"/* ~/.themes/ 2>/dev/null || true
    cp -r "$FONT_DIR"/* ~/.fonts/ 2>/dev/null || true
    cp -r "$FONT_DIR"/* ~/.local/share/fonts/ 2>/dev/null || true
    sudo cp -r "$THEME_DIR"/* /usr/share/themes/ 2>/dev/null || warn "Could not copy system themes (need sudo)"
    sudo cp -r "$THEME_DIR"/* /usr/share/icons/ 2>/dev/null || warn "Could not copy system icons (need sudo)"
}

function restore_system_files() {
    info "Restoring system config files..."
    sudo cp -r "$SYSTEM_DIR"/* /etc/ || warn "Some files may not be restored due to permissions."
}

function finish() {
    echo
    success "Restore complete!"
    echo -e "${YELLOW}Please log out and log back in, or reboot, to see all changes take effect.${NC}"
    echo -e "${YELLOW}Also manually reapply themes in KDE settings if needed.${NC}"
}

clear
confirm
check_requirements
restore_configs
restore_packages
restore_themes_and_fonts
restore_system_files
finish