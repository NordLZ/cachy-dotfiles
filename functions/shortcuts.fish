#!/usr/bin/env fish

set -l script_dir (path dirname (path resolve (status filename)))
set -l config $argv[1]
set -l output "$script_dir/../.gnome/gnome-settings.dconf"

# --------------------------------------------------
# 1. Validate dependencies and arguments
# --------------------------------------------------

if not type -q jq
    echo "Error: jq is not installed." >&2
    exit 1
end

if test -z "$config"
    echo "Usage: shortcuts.fish shortcuts.json" >&2
    exit 1
end

if not test -f "$config"
    echo "Error: Config file not found: $config" >&2
    exit 1
end

# --------------------------------------------------
# 2. Validate JSON
# --------------------------------------------------

jq -e '
    .shortcut |
    if type == "array" then
        all(.[];
            (.name | type == "string") and
            (.command | type == "string") and
            (.binding | type == "string")
        )
    else
        false
    end
' "$config" > /dev/null

or begin
    echo "Error: Invalid JSON or missing shortcut fields." >&2
    exit 1
end

set -l count (jq '.shortcut | length' "$config")
or exit 1

# --------------------------------------------------
# 3. Prepare output
# --------------------------------------------------

mkdir -p (dirname "$output")
or begin
    echo "Error: Could not create output directory." >&2
    exit 1
end

set -l tmpfile (mktemp "$output.tmp.XXXXXX")
or begin
    echo "Error: Could not create temporary file." >&2
    exit 1
end

# --------------------------------------------------
# 4. Generate configuration
# --------------------------------------------------

begin
    echo "[org/gnome/settings-daemon/plugins/media-keys]"
    echo "control-center=['<Super>comma']"

    set -l paths

    if test $count -gt 0
        for i in (seq 0 (math $count - 1))
            set -a paths "'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$i/'"
        end
    end

    echo "custom-keybindings=[$(string join ', ' $paths)]"
    echo

    if test $count -gt 0
        for i in (seq 0 (math $count - 1))
            echo "[org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$i]"

            for field in name command binding
                set -l value (jq -er --arg field "$field" ".shortcut[$i][\$field] | select(type == \"string\")" "$config")
                or begin
                    echo "Error: Could not read $field from shortcut $i." >&2
                    rm -f "$tmpfile"
                    exit 1
                end

                echo "$field='$value'"
            end

            echo
        end
    end
end > "$tmpfile"

or begin
    echo "Error: Failed to generate configuration." >&2
    rm -f "$tmpfile"
    exit 1
end


# --------------------------------------------------
# 5. Update configuration without duplicates
# --------------------------------------------------

set -l existing (mktemp "$output.tmp.XXXXXX")
or begin
    echo "Error: Could not create temporary file." >&2
    rm -f "$tmpfile"
    exit 1
end

# Preserve everything before the Custom Keybindings marker.
if test -f "$output"
    awk '
        /^# Custom Keybindings$/ {
            exit
        }
        {
            print
        }
    ' "$output" > "$existing"
    or begin
        echo "Error: Could not filter existing configuration." >&2
        rm -f "$tmpfile" "$existing"
        exit 1
    end
end

# Remove trailing blank lines from preserved content.
sed -i -e ':a' -e '/^\n*$/{$d;N;ba' -e '}' "$existing"
or begin
    echo "Error: Could not normalize whitespace." >&2
    rm -f "$tmpfile" "$existing"
    exit 1
end

# Add exactly one blank line before the marker.
begin
    if test -s "$existing"
        cat "$existing"
        echo
    end

    echo "# Custom Keybindings"
    echo
    cat "$tmpfile"
end > "$output.tmp"
or begin
    echo "Error: Could not generate final configuration." >&2
    rm -f "$tmpfile" "$existing" "$output.tmp"
    exit 1
end

# Replace original configuration.
mv "$output.tmp" "$output"
or begin
    echo "Error: Could not update configuration." >&2
    rm -f "$tmpfile" "$existing" "$output.tmp"
    exit 1
end

rm "$tmpfile" "$existing"
or exit 1

echo "Configuration successfully updated: $output"
