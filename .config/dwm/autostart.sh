#!/usr/bin/env bash

dwmblocks & 
picom &

kdeconnect-indicator &
dunst &

xautolock -time 15 -notify 30 -notifier "notify-send 'Locking in 30 seconds!'" -locker "betterlockscreen -l" &

feh "$HOME/Wallpaper/0002.jpg" --bg-fill &
