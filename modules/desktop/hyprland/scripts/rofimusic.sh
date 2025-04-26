#!/usr/bin/env bash

# Directory for icons
iDIR="$HOME/.config/hypr/icons"

# Note: You can add more options below with the following format:
# ["TITLE"]="link"

# Define menu options as an associative array
declare -A menu_options=(
  ["Mafumafu instrumentals"]="https://www.youtube.com/playlist?list=PLCnIFNC6ZVTPfiIUryykErt6rGLJGWXe_"
  ["Recap 2025 dec - feb"]="https://youtube.com/playlist?list=LRSRzrgs6Du9PfQ71-tDg44ATaBwh5bW7Mk11&si=azo7tymXi7KTuvTZ"
  ["Amy Carty Radio"]="https://www.youtube.com/watch?v=4YEypDiRyS4&list=RD4YEypDiRyS4&start_radio=1"
  
)

# Function for displaying notifications
notification() {
  notify-send -e -t 2500 -u normal -i "$iDIR/music.png" "Playing now: $@"
}

# Main function
main() {
  r_override="entry{placeholder:'Search Music...';}listview{lines:9;}"
  choice=$(printf "%s\n" "${!menu_options[@]}" | rofi -dmenu -theme-str "$r_override" -theme ~/.config/rofi/launchers/type-2/style-2.rasi -i -p "") # type-1, style-2

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${menu_options[$choice]}"

  notification "$choice"
  
  # Check if the link is a playlist
  if [[ $link == *playlist* ]]; then
    mpv --shuffle --no-video "$link"
  else
    mpv "$link"
  fi
}

# Check if an online music process is running and send a notification, otherwise run the main function
pkill mpv && notify-send -e -t 2500 -u low -i "$iDIR/music.png" "Playback stopped" || main
