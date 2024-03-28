#!/usr/bin/env nu
# vim: set ft=nu:

# ─[ Emotive Package Management ]───────────────────────────────────────────

# The following configuration snafu has arisen: I want to use paru to manage
# packages as it seems more powerful than yay, but the way that yay and yeet
# work as aliases for these commands is too good to not keep.
export alias yay = paru -Syu
export alias yeet = paru -Rnsc
export alias eet = sudo pacman -Rnsc
