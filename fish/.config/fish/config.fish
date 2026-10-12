source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
end

# Set default editor for standard tools and sudoedit
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim

# Sudo expansions
for cmd in systemctl journalctl mount umount docker docker-compose
    abbr -a $cmd "sudo $cmd"
end

# System & Tool Shortcuts
abbr -a p 'sudo pacman'
abbr -a kys 'poweroff'
abbr -a v 'nvim'
abbr -a lg 'lazygit'

# Custom editdotfiles command & alias
function editdotfiles
    cd ~/dotfiles && nvim .
end

abbr -a d 'editdotfiles'
