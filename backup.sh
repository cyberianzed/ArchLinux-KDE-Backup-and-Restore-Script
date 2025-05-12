#!/bin/bash

# ============================================================================
# Arch Linux Backup Script
# Backs up dotfiles, package lists, themes, fonts, and system configurations.
# Friendly and interactive, designed for clarity and safety.
# ============================================================================

set -euo pipefail

BACKUP_DIR="$(pwd)/arch-backup"
CONFIG_FILE="backup.conf"
CONFIG_DIR="$BACKUP_DIR/configurations"
THEME_DIR="$BACKUP_DIR/themes"
FONT_DIR="$BACKUP_DIR/fonts"
SYSTEM_DIR="$BACKUP_DIR/system"
PKG_FILE="$BACKUP_DIR/pkglist.txt"
AUR_FILE="$BACKUP_DIR/aurpkglist.txt"

# Colors for messages
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m" # No Color

function info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

function success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

function warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

function error_exit() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

function confirm() {
    read -rp "$(echo -e "${YELLOW}Proceed with backup? (y/n): ${NC}")" choice
    case "$choice" in
        y|Y ) ;;
        * ) info "Backup aborted by user."; exit 0;;
    esac
}

function check_dependencies() {
    for cmd in pacman yay cp sudo; do
        if ! command -v "$cmd" &> /dev/null; then
            error_exit "Required command '$cmd' is not installed. Please install it and rerun the script."
        fi
    done
}

function prepare_dirs() {
    mkdir -p "$CONFIG_DIR" "$THEME_DIR" "$FONT_DIR" "$SYSTEM_DIR"
}

function display_overview() {
    echo -e "${GREEN}Arch Linux Backup Utility${NC}"
    echo "This script will:"
    echo "1. Back up the following configuration files/directories from $CONFIG_FILE."
    echo "2. Export your list of installed packages (pacman and AUR)."
    echo "3. Copy user and system themes."
    echo "4. Copy installed fonts."
    echo "5. Back up basic system configuration files."
}

function backup_dotfiles() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        error_exit "Missing config file: $CONFIG_FILE"
    fi
    info "Backing up dotfiles..."
    while read -r file; do
        [[ -e $file ]] && cp -r --parents "$file" "$CONFIG_DIR" || warn "Not found: $file"
    done < "$CONFIG_FILE"
}

function backup_packages() {
    info "Saving installed package lists..."
    pacman -Qqe > "$PKG_FILE"
    yay -Qqe > "$AUR_FILE" || warn "Failed to list AUR packages. Is yay installed?"
}

function backup_themes_and_fonts() {
    info "Backing up themes and fonts..."
    [[ -d "$HOME/.themes" ]] && cp -r "$HOME/.themes" "$THEME_DIR"
    [[ -d "$HOME/.icons" ]] && cp -r "$HOME/.icons" "$THEME_DIR"
    sudo cp -r /usr/share/themes "$THEME_DIR" 2>/dev/null || warn "Unable to access /usr/share/themes"
    sudo cp -r /usr/share/icons "$THEME_DIR" 2>/dev/null || warn "Unable to access /usr/share/icons"
    [[ -d "$HOME/.fonts" ]] && cp -r "$HOME/.fonts" "$FONT_DIR"
    [[ -d "$HOME/.local/share/fonts" ]] && cp -r "$HOME/.local/share/fonts" "$FONT_DIR"
}

function backup_system_configs() {
    info "Backing up system config files..."
    for f in /etc/default/grub /etc/X11 /etc/lightdm /etc/sddm.conf; do
        [[ -e $f ]] && sudo cp -r "$f" "$SYSTEM_DIR" || warn "System config not found: $f"
    done
}

# Main Execution
clear
display_overview
confirm
check_dependencies
prepare_dirs
backup_dotfiles
backup_packages
backup_themes_and_fonts
backup_system_configs
success "Backup completed successfully. Files stored in: $BACKUP_DIR"