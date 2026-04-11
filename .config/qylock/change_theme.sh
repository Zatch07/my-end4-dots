#!/usr/bin/env bash

THEME_DIR="$HOME/.config/qylock/themes"
THEME_FILE="$HOME/.config/qylock/theme"

# Get a list of themes
SELECTED_THEME=$(find "$THEME_DIR" -maxdepth 2 -type f \( -name "Main.qml" -o -name "shell.qml" \) -exec dirname {} \; | sort -u | sed "s|$THEME_DIR/||" | fzf --prompt="Select Lockscreen Theme: " --height=15 --reverse --border)

if [ -n "$SELECTED_THEME" ]; then
    echo "$SELECTED_THEME" > "$THEME_FILE"
    notify-send "Lockscreen Update" "Theme changed to: $SELECTED_THEME" -i "preferences-desktop-screensaver"
fi
