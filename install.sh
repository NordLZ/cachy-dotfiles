#!/usr/bin/env bash

set -e # Exit immediately if a command fails

echo "Starting system setup..."

# 1. Update Package Databases
echo "Updating package databases..."
sudo pacman -Sy --noconfirm

# 2. Define Package List (All available in official CachyOS/Arch repos)
PACKAGES=(
    # Development & Tools
    gcc
    tree-sitter-cli
    ripgrep
    fd
    tree
    tealdeer #tldr
    lazygit
    btop

    # Fonts
    ttf-jetbrains-mono-nerd

    # Media & Internet
    mpv
    torbrowser-launcher
    spotify-launcher
    qbittorrent

    # Productivity & Apps
    vscodium
    obsidian
    ghostty
    calibre
    czkawka-gui
    libreoffice-fresh
)

# 3. Install Packages via Pacman
echo "Installing packages..."
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# Load GNOME settings into dconf database
if command -v dconf >/dev/null 2>&1; then
    echo "Loading GNOME settings..."
    dconf load / < "$HOME/dotfiles/.gnome/gnome-settings.dconf"
else
    echo "Error: dconf CLI tool is not installed."
fi

# Set GNOME background image
WALLPAPER_PATH="$HOME/dotfiles/background.jpg" 

if [[ -f "$WALLPAPER_PATH" ]]; then
    if command -v gsettings >/dev/null 2>&1; then
        IMG_URI="file://$(realpath "$WALLPAPER_PATH")"
        gsettings set org.gnome.desktop.background picture-uri "$IMG_URI"
        gsettings set org.gnome.desktop.background picture-uri-dark "$IMG_URI"
        echo "Background set successfully."
    else
        echo "Error: gsettings is not installed."
    fi
else
    echo "Error: Wallpaper file not found at '$WALLPAPER_PATH'."
fi
