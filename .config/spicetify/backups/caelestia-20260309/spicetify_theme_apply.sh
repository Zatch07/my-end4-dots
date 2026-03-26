#!/usr/bin/env bash

# This script is triggered by Matugen to refresh Spotify's theme colors
# based on your current wallpaper.

# Get the current theme to avoid unnecessary full applies
theme=$(spicetify config current_theme)

# Check if the theme is already set to caelestia
if [[ "$theme" != "caelestia" ]]; then
  # First time setup or theme switch: full apply required
  spicetify config current_theme caelestia
  spicetify apply
else
  # Use 'refresh -s' to update styles/colors without restarting the app
  # This is much faster and doesn't stop your music
  spicetify refresh -s
fi