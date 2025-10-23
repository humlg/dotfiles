#!/bin/bash

# Simple toggle for hyprsunset
if pgrep -x "hyprsunset" > /dev/null; then
    pkill -x hyprsunset
    notify-send "Blue light filter: OFF"
else
    nohup hyprsunset --temperature 3500
    notify-send "Blue light filter: ON"
fi
