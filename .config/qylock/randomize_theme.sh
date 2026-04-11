#!/usr/bin/env bash

THEME_DIR="$HOME/.config/qylock/themes"
THEME_FILE="$HOME/.config/qylock/theme"

# Find themes that have either a 'Main.qml' (for Qylock wrappers) or a 'shell.qml' (for Native themes like Nierlock)
RANDOM_THEME=$(find "$THEME_DIR" -maxdepth 2 -type f \( -name "Main.qml" -o -name "shell.qml" \) -exec dirname {} \; | sort -u | sed "s|$THEME_DIR/||" | shuf -n 1)

if [ -n "$RANDOM_THEME" ]; then
    echo "$RANDOM_THEME" > "$THEME_FILE"
fi