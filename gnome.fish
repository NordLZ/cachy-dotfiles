#!/usr/bin/env fish

set -l config_file "keybindings.toml"
set -l dconf_target "$HOME/dotfiles/.gnome/gnome-settings.dconf"

if not test -f "$config_file"
    echo "Error: $config_file not found in the current directory."
    exit 1
end

mkdir -p (dirname "$dconf_target")

# Use tomlq to query the TOML array and output fields separated by tabs (\t)
set -l entries (tomlq -r '.shortcut[] | "\(.name)\t\(.command)\t\(.binding)"' "$config_file")

if test -z "$entries"
    echo "Warning: No shortcuts found in $config_file"
    exit 0
end

set -l paths
set -l sections
set -l count 0

for entry in $entries
    # Split the line by tabs into distinct variables
    set -l fields (string split \t "$entry")
    set -l name $fields[1]
    set -l command $fields[2]
    set -l binding $fields[3]

    set -l path "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$count/"
    set -a paths "'$path'"

    set -a sections "[org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$count]"
    set -a sections "name='$name'"
    set -a sections "command='$command'"
    set -a sections "binding='$binding'"
    set -a sections "" # Blank line separator

    set count (math $count + 1)
end

# Build the final dconf configuration output
set -l paths_str (string join ", " $paths)
set -l output "[org/gnome/settings-daemon/plugins/media-keys]"
set -a output "custom-keybindings=[$paths_str]"
set -a output ""

for line in $sections
    set -a output "$line"
end

printf "%s\n" $output > "$dconf_target"

echo "Successfully generated $count keybindings in $dconf_target"
