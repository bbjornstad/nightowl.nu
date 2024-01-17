#!/usr/bin/env nu

#SPDX-FileCopyrightText: 2024 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
#SPDX-License-Identifier: GPL-3.0-only

#Copyright (C) 2024 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

#This program is free software: you can redistribute it and/or modify it under
#the terms of the GNU General Public License as published by the Free Software
#Foundation, version 3.

#This program is distributed in the hope that it will be useful, but WITHOUT ANY
#WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
#PARTICULAR PURPOSE. See the GNU General Public License for more details.

#You should have received a copy of the GNU General Public License along with
#this program. If not, see <https://www.gnu.org/licenses/>.

# ╓──────────────────────────────────────────────────────────────────────╖
# ║ nushell aliases                                                      ║
# ╙──────────────────────────────────────────────────────────────────────╜

# ─[ Neovim Aliases ]───────────────────────────────────────────────────────
# use of vim on the command line will actually invoke nvim instead. Also set up
# two aliases to adjust the background color if desired.
export def dnvim [ ...args ] {
    with-env { NIGHTOWL_BACKGROUND_STYLE: "dark" } {
        nvim ...$args
    }
}
export def lnvim [ ...args ] {
    with-env { NIGHTOWL_BACKGROUND_STYLE: "light" } {
        nvim ...$args
    }
}

# ─[ File Managers ]────────────────────────────────────────────────────────
# aliases for nnn with the correct environment variables, presumably this was to
# allow nnn preview to work correctly.
export alias nnn = with-env { MANPAGER: bat } { nnn }

# ─[ Hyprland ]─────────────────────────────────────────────────────────────
# aliases for Hyprland tiling desktop window manager
# TODO: modify the below by pulling into a separate module or overlay that can
# be included and then we can also add any additional implementations there.
export alias wayedit = killall -SIGUSR2 waybar

# help formatting: currently broken?
# - Should set up bat the correct way to display the help file for the given
#   command.
# export def help [command: string] {
#   $command out+err> | bat --plain --language=help
# }

# ─[ LS Aliases ]───────────────────────────────────────────────────────────
# Simply defines a few aliases that I use to query directories in a more
# specific fashion.
export alias lsd = ls --long
export alias lsa = ls --long
export alias ald = ls --long --all
export alias aldt = ls --long --all
export alias lsl = ls --long

# ─[ Emotive Package Management ]───────────────────────────────────────────
# The following configuration snafu has arisen: I want to use paru to manage
# packages as it seems more powerful than yay, but the way that yay and yeet
# work as aliases for these commands is too good to not keep.
export alias yay = paru -Syu
export alias yeet = paru -Rnsc
export alias eet = sudo pacman -Rnsc

# ─[ Searching and File System Navigation ]─────────────────────────────────
# cat -> bat
# grep -> rg
# find -> fd
# cd -> z
export alias cat = bat
export alias grep = rg
export alias find = fd

export alias cd = __zoxide_z

# ─[ Section: Manpager Woes ]───────────────────────────────────────────────
# add the ability to switch manpagers with an easy alias; helpful for when nvim
# is down and we still need to read manual pages.
export def sman [
    ...pages
] {
    with-env {MANPAGER: "bat -l Manpage"} {
        man $pages
    }
}


