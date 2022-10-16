#!/usr/bin/env bash

alacritty \
  -o "custom_cursor_colors=true" \
  -o "colors.cursor.cursor='0x282828'" \
  -o "font.size=11" \
  -o "window.padding.x=100" \
  -o "window.padding.y=38" \
  --class gcalcli,gcalcli --hold \
  -e bash -c '
      tput sc
      bash -c "echo -e \"\n \" && gcalcli calm --details=all"
      while true; do
        sleep 10
        tput rc
        bash -c "echo -e \"\n \" && gcalcli calm --details=all"
      done
    '
