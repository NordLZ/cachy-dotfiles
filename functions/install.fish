#!/usr/bin/env fish

# TODO: make sure rustup is installed and install the latest version. also paru.
function install_packages
    echo "Installing packages..."

    set -l packages \
        gcc \
        stow \
        tree-sitter-cli \
        ripgrep \
        fd \
        tree \
        tealdeer \
        lazygit \
        btop \
        ncdu \
        neovim \
        github-cli \
        ttf-jetbrains-mono-nerd \
        mpv \
        torbrowser-launcher \
        spotify-launcher \
        qbittorrent \
        vscodium \
        obsidian \
        ghostty \
        calibre \
        czkawka-gui \
        libreoffice-fresh \
        ibus \
        ibus-libpinyin \
        m17n-db

    sudo pacman -Syu --needed --noconfirm $packages
    or return 1

    echo "Installing AUR packages..."

    set -l aur_packages \
        ibus-m17n \
        ie-r

    paru -S --needed --noconfirm $aur_packages
    or return 1

    echo "Packages installed."
end

function install_shortcuts --argument-names dotfiles_dir
    echo "Generating GNOME shortcuts..."

    set -l script "$dotfiles_dir/functions/shortcuts.fish"
    set -l config "$dotfiles_dir/assets/shortcuts.json"

    if not test -f "$script"
        echo "Error: shortcuts.fish not found." >&2
        return 1
    end

    if not test -f "$config"
        echo "Error: shortcuts.json not found." >&2
        return 1
    end

    fish "$script" "$config"
    or return 1

    echo "Shortcuts generated."
end

function install_gnome --argument-names dotfiles_dir
    echo "Configuring GNOME..."

    set -l dconf_file "$dotfiles_dir/.gnome/gnome-settings.dconf"
    set -l wallpaper "$dotfiles_dir/assets/background.jpg"

    # Load dconf settings.
    if not type -q dconf
        echo "Error: dconf is not installed." >&2
        return 1
    end

    if not test -f "$dconf_file"
        echo "Error: dconf configuration not found." >&2
        return 1
    end

    dconf load / < "$dconf_file"
    or return 1

    # Set wallpaper.
    if not type -q gsettings
        echo "Error: gsettings is not installed." >&2
        return 1
    end

    if not test -f "$wallpaper"
        echo "Error: Wallpaper not found." >&2
        return 1
    end

    set -l wallpaper_uri "file://$wallpaper"

    gsettings set org.gnome.desktop.background picture-uri "$wallpaper_uri"
    or return 1

    gsettings set org.gnome.desktop.background picture-uri-dark "$wallpaper_uri"
    or return 1

    echo "GNOME configured."
end
