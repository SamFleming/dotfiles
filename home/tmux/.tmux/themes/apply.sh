#!/bin/sh
# tmux 3.7 can fire the theme hooks before client_theme updates, so wait before reading it.
sleep 0.5
if [ "$(tmux display -p -c "$1" '#{client_theme}')" = light ]; then flavour=latte; else flavour=frappe; fi
tmux source-file ~/.tmux/themes/catppuccin-$flavour.tmux
