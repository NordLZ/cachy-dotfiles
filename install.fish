#!/usr/bin/env fish

# --------------------------------------------------
# Setup
# --------------------------------------------------

set -l dotfiles_dir (path dirname (path resolve (status filename)))

cd "$dotfiles_dir"
or exit 1

echo "Starting system setup..."


# Load functions.
source "$dotfiles_dir/functions/install.fish"

echo "Starting system setup..."

install_packages
or exit 1

install_shortcuts "$dotfiles_dir"
or exit 1

install_gnome "$dotfiles_dir"
or exit 1

echo "System setup completed successfully!"
