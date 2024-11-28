#!/usr/bin/env bash

### AUTOSTART PROGRAMS ###
lxsession &
picom --daemon &
~/.config/emacs/bin/doom emacs --daemon
nm-applet &
sleep 1
conky -c "$HOME"/.config/conky/qtile/01/"$COLORSCHEME".conf || echo "Couldn't start conky."
nitrogen --restore &
blueman-applet &
dunst &
signal-desktop &
# Start xss-lock with i3lock
xss-lock -- i3lock-fancy -n &
# Screen blanking and DPMS settings
xset s 300 5
xset dpms 300 600 900
# Cursor speed
xset r rate 300 50
