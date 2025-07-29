#!/bin/sh

export DISPLAY=:0

# Merge your Xresources settings
xrdb -merge ~/.Xresources

# Set keyboard options (clear any previous options)
setxkbmap -option ""

# Set up GPG environment variables
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Start or reload gpg-agent
gpgconf --launch gpg-agent

# Start qtile as your window manager
exec /usr/bin/qtile start
