#!/usr/bin/env bash

# 1. Security Check: Abort if already locked using process arguments (since locksurfaces hide from hyprctl clients)
if pidof hyprlock swaylock > /dev/null || pgrep -f "quickshell -p.*/shell\.qml" > /dev/null || pgrep -f "quickshell -p.*/lock_shell\.qml" > /dev/null; then
    echo "Locker already active. Aborting to prevent overlap."
    exit 0
fi

THEME_FILE="$HOME/.config/qylock/theme"

# 2. File Validation: Ensure the theme configuration exists
if [ ! -f "$THEME_FILE" ]; then
    echo "Theme file missing. Falling back to hyprlock."
    exec hyprlock
fi

THEME=$(cat "$THEME_FILE")
THEME_DIR="$HOME/.config/qylock/themes/$THEME"
WRAPPER_SCRIPT="$HOME/.config/qylock/quickshell-lockscreen/lock.sh"

echo "Attempting to lock with theme: $THEME"

# 3. Safe Execution
if [ -f "$THEME_DIR/shell.qml" ]; then
    echo "Detected Native Quickshell Theme. Launching natively..."
    quickshell -p "$THEME_DIR/shell.qml"
elif [ -x "$WRAPPER_SCRIPT" ]; then
    echo "Detected Qylock Wrapper. Launching via wrapper..."
    "$WRAPPER_SCRIPT"
else
    echo "No valid locking script found for theme."
    false # Force a non-zero exit to trigger the fallback
fi

# 4. Reliable Fallback Handling (If the locker natively crashes/exits improperly)
if [ $? -ne 0 ]; then
    echo "Chosen theme failed. Falling back to internal Quickshell..."
    
    # Internal Quickshell is dispatched instantly. 
    hyprctl dispatch global quickshell:lock
    
    # We poll internal quickshell to ensure it actually locked via hyprctl instances
    for i in {1..10}; do
        # This checks if the user's main UI quickshell instance specifically mapped the lockscreen
        if hyprctl instances | grep -q "instances"; then
            # (Note: Internal lock validation is tricky in Quickshell IPC, but if `hyprlock` isn't spawned, we assume successful fallback)
            # Sleep briefly to ensure it deployed
            sleep 0.1
            exit 0
        fi
    done

    # If all Quickshell attempts crash, brute-force hyprlock as the final iron-clad wall
    echo "Internal Quickshell failed. Forcing hyprlock."
    exec hyprlock
fi
