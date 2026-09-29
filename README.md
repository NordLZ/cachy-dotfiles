# Cachyos Dotfiles

## Makefile
To install: `make all`
To uninstall: `make delete`
### GNU stow
Dirs/files with a . (dot) in front are ignored and will not be symlinked

## install.sh (gnome)
Sets dconf and gsettings settings
TODO: mimeapps

## Wheel nopasswd
1. sudo usermod -aG wheel adam
2. visudo
3. comment out last line
4. uncomment this line: `%wheel ALL=(ALL:ALL) NOPASSWD: ALL`

## Packages
- nerdfont (ttf-jetbrains-mono-nerd)
- git (email and name)
- gh (set up auth)
- mac cursor
- mpv
- tor
- spotify
- vscodium
- obsidian
- ghostty
- qbittorrent
- calibre
- czkawka
- libreoffice-fresh
- tree, tldr, fd, lazygit, btop

### git
- git (email and name)
- gh (set up auth)

### nvim packages
- tree-sitter-cli (IMPORTANT)
- ripgrep
- nil
- nixpkgs-fmt
- nodejs
- gcc
- luaPackages.tree-sitter-cli
- lua-language-server
- alejandra
- nixd

## fish
- expand sudo abbreviations
### aliases
kys, v, lg (lazygit), d (edit dotfiles)

## Autologin
[Docs](https://help.gnome.org/system-admin-guide/login-automatic.html)

Edit the /etc/gdm/custom.conf file and make sure that the [daemon] section in the file specifies the following:
custom.conf

[daemon]
AutomaticLoginEnable=True
AutomaticLogin=username

Replace the username with the user that you want to be automatically logged in.
