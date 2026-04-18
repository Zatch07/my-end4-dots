#!/usr/bin/env bash

# 1. State Tracking Fix: Block and wait if an actual locker is already running.
# We exclude the main 'shell.qml' (the taskbar) to allow Qylock to launch.
if pgrep -f "quickshell.*lock_shell\.qml|hyprlock" > /dev/null; then
    echo "Locker already active. Waiting for it to close..."
    tail --pid=$(pgrep -n -f "lock_shell|hyprlock" | head -1) -f /dev/null
    exit 0
fi

THEME_FILE="$HOME/.config/qylock/theme"
THEME=$(cat "$THEME_FILE" 2>/dev/null || echo "nier-automata")
THEME_DIR="$HOME/.config/qylock/themes/$THEME"
WRAPPER_SCRIPT="$HOME/.config/qylock/quickshell-lockscreen/lock.sh"

echo "Attempting to lock with theme: $THEME"

# 2. Context-Aware Execution (Supports Nierlock natively AND legacy themes like Hollow Knight)
if [ -f "$THEME_DIR/shell.qml" ]; then
    echo "Detected Native Quickshell Theme. Launching natively..."
    quickshell -p "$THEME_DIR/shell.qml"
elif [ -x "$WRAPPER_SCRIPT" ]; then
    echo "Detected Qylock Wrapper. Launching via wrapper..."
    "$WRAPPER_SCRIPT"
else
    false # Trigger fallback
fi

# 3. Direct Fallback to Hyprlock
EXIT_CODE=$?
# If quickshell is killed smoothly by hypridle unlock (143) it's not a crash.
if [ $EXIT_CODE -ne 0 ] && [ $EXIT_CODE -ne 143 ]; then
    # Double check the session is actually still locked before throwing up hyprlock
    if loginctl show-session $XDG_SESSION_ID -p State --value 2>/dev/null | grep -q "locked"; then
        echo "Qylock crashed with code $EXIT_CODE. Forcing Hyprlock as fallback."
        exec hyprlock
    fi
fi
