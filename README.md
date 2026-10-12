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
2. EDITOR=vim sudo visudo
3. comment out last line
4. uncomment this line: `%wheel ALL=(ALL:ALL) NOPASSWD: ALL`
5. restart

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

## Rebind caps lock to backspace
1. Run this command. This is persistant
`gsettings set org.gnome.desktop.input-sources xkb-options "['caps:backspace']"`
2. If you want to revert, run
`gsettings reset org.gnome.desktop.input-sources xkb-options`

## Desktop
### Limit clock speed on AMD graphics card
1. Edit /etc/default/limine. Append "amdgpu.ppfeaturemask=0xffffffff" to kernel cmdline, to enable overclocking. It should look like this:
`
KERNEL_CMDLINE[default]+="quiet nowatchdog splash rw rootflags=subvol=/@ rd.luks.uuid=8621d38e-a957-461e-a2aa-9e3a7152b6fc root=/dev/mapper/luks-8621d38e-a957-461e-a2aa-9e3a7152b6fc amdgpu.ppfeaturemask=0xffffffff"
`
2. Install LACT
3. Make a new profile and limit GPU clock to 1500 Mhz (rx 590)
