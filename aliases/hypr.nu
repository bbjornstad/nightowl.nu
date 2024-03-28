#!/usr/bin/env nu
# vim: set ft=nu:

# ─[ Hyprland ]─────────────────────────────────────────────────────────────

# aliases for Hyprland tiling desktop window manager
# TODO: modify the below by pulling into a separate module or overlay that can
# be included and then we can also add any additional implementations there.
export alias wayedit = killall -SIGUSR2 waybar
