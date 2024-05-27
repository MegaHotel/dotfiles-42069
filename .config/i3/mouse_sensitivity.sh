#!/bin/bash

# Check if the sensitivity value is provided as a command-line argument
if [ $# -eq 0 ]; then
  echo "Please provide the desired mouse sensitivity as a command-line argument."
  echo "Usage: $0 <sensitivity>"
  echo "Example: $0 0.5"
  exit 1
fi

# Get the sensitivity value from the command-line argument
sensitivity=$1

# Validate the sensitivity value
if [[ $(echo "$sensitivity >= -1.0 && $sensitivity <= 1.0" | bc -l) -eq 0 ]]; then
  echo "Invalid sensitivity value. Please provide a value between -1.0 and 1.0."
  exit 1
fi

# Get the ID of the desired mouse device
mouse_id=$(xinput list | grep -i 'Logitech G Pro' | grep -i 'slave.*pointer' | awk '{print $6}' | cut -d'=' -f2)

# Set the mouse sensitivity using xinput
xinput set-prop "$mouse_id" "libinput Accel Speed" "$sensitivity"

echo "Mouse sensitivity set to $sensitivity"
