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
    "qylock"
    "rofi"
    "skwd"
    "spicetify"
    "swww"
    "wal"
    "waybar"
    "wlogout"
)

# Folders that need special filtering (e.g. skip cache dirs)
# Format: "folder:exclude1:exclude2"
FILTERED_FOLDERS=(
    "vivaldi:Cache:Code Cache:GPUCache:GrShaderCache:ShaderCache:User Data:Service Worker:Default/Storage"
    "vesktop:sessionData:Crashpad:SingletonLock:SingletonCookie:SingletonSocket:state.json"
    "Code/User:workspaceStorage:globalStorage:Cache:CachedData:logs:User/History"
)

# Create config directory structure in the backup repo
mkdir -p .config

for folder in "${FOLDERS[@]}"; do
    if [ -d "${CONFIG_DIR}/${folder}" ]; then
        echo "Backing up .config/${folder}..."
        rsync -aP --delete "${CONFIG_DIR}/${folder}/" ".config/${folder}/"
    fi
done

# Backup filtered folders (skip cache/GPU junk to keep repo small)
for entry in "${FILTERED_FOLDERS[@]}"; do
    IFS=':' read -ra parts <<< "$entry"
    folder="${parts[0]}"
    if [ -d "${CONFIG_DIR}/${folder}" ]; then
        echo "Backing up .config/${folder} (filtered)..."
        exclude_args=()
        for (( i=1; i<${#parts[@]}; i++ )); do
            exclude_args+=(--exclude="${parts[$i]}/")
        done
        mkdir -p ".config/${folder}"
        rsync -aP --delete "${exclude_args[@]}" "${CONFIG_DIR}/${folder}/" ".config/${folder}/"
    fi
done

# Backup User scripts and Cursors
if [ -d "${HOME}/.local/bin" ]; then
    echo "Backing up .local/bin..."
    mkdir -p ".local/bin"
    rsync -aP --delete "${HOME}/.local/bin/" ".local/bin/"
fi

if [ -d "${HOME}/.icons" ]; then
    echo "Backing up .icons (Cursors)..."
    mkdir -p ".icons"
    rsync -aP --delete "${HOME}/.icons/" ".icons/"
fi

# Backup standalone files from home directory
STANDALONE_FILES=(
    "END4_CHANGELOG.md"
    ".quicklinks"
)

for file in "${STANDALONE_FILES[@]}"; do
    if [ -f "${HOME}/${file}" ]; then
        echo "Backing up ${file}..."
        cp "${HOME}/${file}" "${BACKUP_DIR}/${file}"
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
