#!/bin/bash

# Gruvbox accent colors (no # prefix for barcolors markup)
yellow="d79921"
green="98971a"
blue="458588"
red="cc241d"
aqua="689d6a"
fg="ebdbb2"
gray="928374"

# Nerd Font icons
i_wifi=$'\uf1eb'        #
i_nowifi=$'\uf127'      #
i_ethernet=$'\uf6ff'    #
i_clock=$'\uf017'       #
i_bat_full=$'\uf240'    #
i_bat_high=$'\uf241'    #
i_bat_mid=$'\uf242'     #
i_bat_low=$'\uf243'     #
i_bat_empty=$'\uf244'   #
i_bat_charge=$'\uf0e7'  #

wifi() {
    iface=$(ip route show default 2>/dev/null | awk '{print $5; exit}')
    if [ -z "$iface" ]; then
        printf "^fg(%s)%s no net^fg()" "$red" "$i_nowifi"
        return
    fi
    if [ -d "/sys/class/net/$iface/wireless" ]; then
        ssid=$(iwctl station "$iface" show 2>/dev/null | awk '/Connected network/ {print $NF}')
        [ -z "$ssid" ] && ssid=$(iw dev "$iface" link 2>/dev/null | awk '/SSID/ {print $2}')
        if [ -n "$ssid" ]; then
            printf "^fg(%s)%s %s^fg()" "$blue" "$i_wifi" "$ssid"
        else
            printf "^fg(%s)%s disconnected^fg()" "$red" "$i_wifi"
        fi
    else
        printf "^fg(%s)%s %s^fg()" "$green" "$i_ethernet" "$iface"
    fi
}

battery() {
    bat_path=""
    for b in /sys/class/power_supply/BAT*; do
        [ -d "$b" ] && bat_path="$b" && break
    done
    [ -z "$bat_path" ] && return

    cap=$(cat "$bat_path/capacity" 2>/dev/null)
    status=$(cat "$bat_path/status" 2>/dev/null)

    if [ "$status" = "Charging" ]; then
        icon="$i_bat_charge"
        color="$green"
    elif [ "$cap" -le 10 ]; then
        icon="$i_bat_empty"
        color="$red"
    elif [ "$cap" -le 30 ]; then
        icon="$i_bat_low"
        color="$yellow"
    elif [ "$cap" -le 60 ]; then
        icon="$i_bat_mid"
        color="$fg"
    elif [ "$cap" -le 85 ]; then
        icon="$i_bat_high"
        color="$fg"
    else
        icon="$i_bat_full"
        color="$fg"
    fi

    printf "^fg(%s)%s %s%%^fg()" "$color" "$icon" "$cap"
}

clock() {
    printf "^fg(%s)%s ^fg(%s)%s^fg()" "$aqua" "$i_clock" "$fg" "$(date '+%a %b %d  %H:%M')"
}

sep() {
    printf "^fg(%s) | ^fg()" "$gray"
}

while true; do
    bar=""
    bar="$bar$(wifi)"
    bar="$bar$(sep)$(battery)"
    bar="$bar$(sep)$(clock) "
    echo "$bar"
    sleep 5
done
