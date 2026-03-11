#!/bin/bash

# This script finds a random wallpaper from a specified directory,
# ensuring it's not the same as the active wallpaper, and sets it with swww.

# Define the directory where your wallpapers are stored
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Check if the directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Error: Wallpaper directory '$WALLPAPER_DIR' not found."
  exit 1
fi

# Get a list of all wallpapers into a Bash array.
# The `mapfile` command with these options correctly handles filenames with spaces or special characters.
mapfile -d $'\0' ALL_WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)

# Check if any wallpapers were found
if [ ${#ALL_WALLPAPERS[@]} -eq 0 ]; then
  echo "No image files found in '$WALLPAPER_DIR'."
  exit 1
fi

# If there's only one wallpaper, there's nothing to change to.
if [ ${#ALL_WALLPAPERS[@]} -le 1 ]; then
  echo "Only one wallpaper found, nothing to change."
  exit 0
fi

# Get the path of the current wallpaper from swww
CURRENT_WALLPAPER=$(swww query | grep -o -m 1 '/.*')

# Create a new array of candidate wallpapers, excluding the current one
CANDIDATE_WALLPAPERS=()
for wallpaper in "${ALL_WALLPAPERS[@]}"; do
    # Trim potential whitespace/newlines from file paths for accurate comparison
    if [[ "$(echo -n "$wallpaper")" != "$(echo -n "$CURRENT_WALLPAPER")" ]]; then
        CANDIDATE_WALLPAPERS+=("$wallpaper")
    fi
done

# If the candidate list is empty (e.g., current wallpaper wasn't in the folder),
# fall back to using the full list to prevent errors.
if [ ${#CANDIDATE_WALLPAPERS[@]} -eq 0 ]; then
    CANDIDATE_WALLPAPERS=("${ALL_WALLPAPERS[@]}")
fi

# Select a random wallpaper from the candidate list
RANDOM_INDEX=$(( RANDOM % ${#CANDIDATE_WALLPAPERS[@]} ))
NEW_WALLPAPER="${CANDIDATE_WALLPAPERS[$RANDOM_INDEX]}"

# Use swww to set the wallpaper with a random transition effect
swww img "$NEW_WALLPAPER" \
    --transition-type random \
    --transition-duration 1 \
    --transition-fps 60

# Rerun matugen with the new wallpaper to generate a new color scheme
matugen image "$NEW_WALLPAPER"
