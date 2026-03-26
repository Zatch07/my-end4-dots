#!/usr/bin/env bash

# Dotfiles backup script
BACKUP_DIR="${HOME}/end4-dots-backup"
CONFIG_DIR="${HOME}/.config"

# Go to the backup directory
cd "$BACKUP_DIR" || exit 1

echo "Copying config files..."

# List of specific end-4 and related config folders to backup
# Avoid grabbing huge cache folders or completely unrelated apps
FOLDERS=(
    "agsv1"
    "btop"
    "doom"
    "fastfetch"
    "fish"
    "fuzzel"
    "gtk-3.0"
    "gtk-4.0"
    "hypr"
    "illogical-impulse"
    "kitty"
    "matugen"
    "nvim"
    "qt5ct"
    "qt6ct"
    "quickshell"
    "rofi"
    "spicetify"
    "swww"
    "vesktop"
    "wal"
    "waybar"
    "wlogout"
)

# Create config directory structure in the backup repo
mkdir -p .config

for folder in "${FOLDERS[@]}"; do
    if [ -d "${CONFIG_DIR}/${folder}" ]; then
        echo "Backing up .config/${folder}..."
        # Sync identically, deleting old files that were removed in your actual setup
        rsync -aP --delete "${CONFIG_DIR}/${folder}/" ".config/${folder}/"
    fi
done

# Check if there are changes
if [[ -z $(git status -s) ]]; then
    echo "No changes found. Everything is already up to date!"
    exit 0
fi

echo ""
echo "Adding changes to Git..."
git add .

# Always use a timestamp commit to keep it fully automated
message="Backup: $(date +'%Y-%m-%d %H:%M:%S')"

# Commit and push securely
git commit -m "$message"
git push -u origin main
echo ""
echo "✅ Backup successfully committed and pushed to GitHub!"
