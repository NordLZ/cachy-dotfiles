#!/usr/bin/env fish

set config $argv[1]
set output ".gnome/gnome-settings.dconf"

if not test -f "$config"
    echo "Usage: shortcuts.fish shortcuts.json" >&2
    exit 1
end

if not type -q jq
    echo "Error: jq is not installed" >&2
    exit 1
end

# Validate JSON.
if not jq empty "$config"
    echo "Error: Invalid JSON in $config" >&2
    exit 1
end

# Get the number of shortcuts.
set count (jq '.shortcut | length' "$config")

# Build custom-keybindings array.
set paths
for i in (seq 0 (math $count - 1))
    set -a paths "'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$i/'"
end

# Ensure output directory exists.
mkdir -p (dirname "$output")

# Append generated configuration.
begin
    echo "[org/gnome/settings-daemon/plugins/media-keys]"
    echo "control-center=['<Super>comma']"
    echo "custom-keybindings=[$(string join ', ' $paths)]"
    echo

    # Generate each custom shortcut.
    for i in (seq 0 (math $count - 1))
        echo "[org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$i]"

        for field in name command binding
            set value (jq -r ".shortcut[$i].$field" "$config")

            if test "$value" = null
                echo "Error: Missing field '$field' in shortcut $i" >&2
                exit 1
            end

            echo "$field='$value'"
        end

        echo
    end
end >> "$output"

echo "Configuration appended to $output"

