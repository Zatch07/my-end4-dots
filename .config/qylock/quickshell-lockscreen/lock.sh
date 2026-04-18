#!/usr/bin/env bash

# Current directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set library paths
export QML2_IMPORT_PATH="$DIR/imports:$QML2_IMPORT_PATH"
export QML_XHR_ALLOW_FILE_READ=1

# Safely get session type using the systemd environment variable
export XDG_SESSION_TYPE="${XDG_SESSION_TYPE:-$(loginctl show-session $XDG_SESSION_ID -p Type --value 2>/dev/null || echo wayland)}"

# User theme preference
CONFIG_FILE="$HOME/.config/qylock/theme"
if [ -n "$1" ]; then
    export QS_THEME="$1"
elif [ -f "$CONFIG_FILE" ]; then
    export QS_THEME=$(cat "$CONFIG_FILE")
else
    export QS_THEME="nier-automata"
fi

export QS_THEME_PATH="$HOME/.config/qylock/themes/$QS_THEME"

echo "Locking with Quickshell using theme: $QS_THEME"

# Gracefully ask existing standalone lockers to close (Do NOT use -9 SIGKILL)
pkill -15 -f "hyprlock|swaylock" 2>/dev/null || true

# Execute lock screen (This will block the script until Quickshell exits)
quickshell -p "$DIR/lock_shell.qml"
