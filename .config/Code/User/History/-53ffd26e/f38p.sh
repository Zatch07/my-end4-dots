#!/usr/bin/env bash
THEME_DIR="$HOME/.config/qylock/themes"
THEME_FILE="$HOME/.config/qylock/theme"
# Find any theme that contains a Main.qml and pick a random one
RANDOM_THEME=$(find "$THEME_DIR" -type f -name "Main.qml" -exec dirname {} \; | sed "s|$THEME_DIR/||" | shuf -n 1)
if [ -n "$RANDOM_THEME" ]; then
    echo "$RANDOM_THEME" > "$THEME_FILE"
    echo "Set next lockscreen theme to: $RANDOM_THEME"
fi
EOF
# 5. Create the smart fallback locker
cat << 'EOF' > ~/.config/qylock/smart_lock.sh
#!/usr/bin/env bash
# Attempt to lock with Qylock natively
~/.config/qylock/quickshell-lockscreen/lock.sh
# If Qylock fails or crashes out immediately:
if [ $? -ne 0 ]; then
    echo "Qylock failed. Falling back to internal Quickshell..."
    hyprctl dispatch global quickshell:lock
    
    # If the internal fallback also fails:
    if [ $? -ne 0 ]; then
        echo "Internal Quickshell lock failed. Falling back to hyprlock..."
        pidof hyprlock || hyprlock
    fi
fi