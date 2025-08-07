#!/usr/bin/env bash

 animationsState=$(hyprctl getoption animations:enabled | awk '/int/ {print $2}')

if [[ "$animationsState" -eq 1 ]]  ; then
    hyprctl keyword animations:enabled 0
    notify-send "Animations" "Disabled" -a "hyprland-icon" -i "$HOME/.icons/hyprland.png" -t 3000
else
    hyprctl keyword animations:enabled 1
    notify-send "Animations" "Enabled" -a "hyprland-icon" -i "$HOME/.icons/hyprland.png" -t 3000
fi
