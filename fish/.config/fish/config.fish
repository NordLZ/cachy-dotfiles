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
abbr -a p 'sudo pacman'
abbr -a systemctl 'sudo systemctl'
abbr -a journalctl 'sudo journalctl'
abbr -a mount 'sudo mount'
abbr -a umount 'sudo umount'

# System & Tool Shortcuts
abbr -a kys 'poweroff'
abbr -a v 'nvim'
abbr -a lg 'lazygit'

# Custom editdotfiles command & alias
function editdotfiles
    cd ~/dotfiles && nvim .
end

abbr -a d 'editdotfiles'
