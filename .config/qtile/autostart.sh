#!/usr/bin/env bash
# Set DP-1-0 to 3840x2160 at 144Hz
#xrandr --output DP-1-0 --mode 3840x2160 --rate 144.00
# Disable HDMI-1
#xrandr --output HDMI-1 --off
# Increase mouse cursor speed
xinput --set-prop 9 "libinput Accel Speed" 1 &
### AUTOSTART PROGRAMS ###
lxsession &
picom --daemon &
#~/.config/emacs/bin/doom emacs --daemon
nm-applet &
sleep 1
#conky -c "$HOME"/.config/conky/qtile/01/"$COLORSCHEME".conf || echo "Couldn't start conky."
xwallpaper --maximize ~/pics/Wallpapers/niemi.png &
blueman-applet &
dunst &
signal-desktop &

# Start screen blanking/lock after 5 min, turn off display after 15 min
xset s on
xset s 300 300
xset +dpms
xset dpms 0 0 900

# Automatic locking screen
xss-lock -- ~/.local/bin/secure-lock &
#xset dpms 300 600 900
# Cursor speed
# Slow xset r rate 300 50
xset r rate 400 40
