#!/bin/bash

# Get battery percentage (for most laptops)
BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT*/capacity)
STATUS=$(cat /sys/class/power_supply/BAT*/status)

# Only notify if battery is discharging and below 15%
if [[ "$STATUS" == "Discharging" && "$BATTERY_LEVEL" -le 15 ]]; then
    notify-send -u critical -t 10000 "🪫 Low battery" "Battery is at ${BATTERY_LEVEL}%!"
fi
