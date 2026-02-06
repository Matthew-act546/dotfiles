#!/usr/bin/env bash

# === OPTIONS ===
OPTIONS=" Shutdown\n Reboot\n Suspend\n Lock\n Logout"

# === ROFI MENU ===
CHOSEN="$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Power:")"

# === ACTIONS ===
case "$CHOSEN" in
    " Shutdown")
        systemctl poweroff
        ;;
    " Reboot")
        systemctl reboot
        ;;
    " Suspend")
        systemctl suspend
        ;;
    " Lock")
        hyprlock   # change this if you use another lockscreen
        ;;
    " Logout")
        hyprctl dispatch exit
        ;;
esac

