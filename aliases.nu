#!/usr/bin/env nu
# vim: set ft=nu:

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

# ------------------------------------------------------------------------------
# use of vim on the command line will actually invoke nvim instead.
export def dnvim [ ...args ] {
    with-env { NIGHTOWL_BACKGROUND_STYLE: "dark" } {
        /usr/bin/nvim $args
    }
}
export def lnvim [ ...args ] {
    with-env { NIGHTOWL_BACKGROUND_STYLE: "light" } {
        /usr/bin/nvim $args
    }
}

export alias nvim = dnvim
export alias vim = nvim

# ------------------------------------------------------------------------------
# aliases for file managers.
export alias nnn = with-env { MANPAGER: bat } { nnn }

# ------------------------------------------------------------------------------
# hyprland specific aliases:
# - restart waybar with a SIGUSR2 signal.
export alias wayedit = killall -SIGUSR2 waybar

# ------------------------------------------------------------------------------
# help formatting: currently broken?
# - Should set up bat the correct way to display the help file for the given
#   command.
# export def help [command: string] {
#   $command out+err> | bat --plain --language=help
# }

# ------------------------------------------------------------------------------
# ls based rebindings: get more information for less keystrokes.
# - Simply defines a few aliases that I use to query directories in a more
#   specific fashion.
export alias lsd = ls --long
export alias lsa = ls --long
export alias ald = ls --long --all
export alias aldt = ls --long --all
export alias lsl = ls --long

# ------------------------------------------------------------------------------
# emotive package management:
# The following configuration snafu has arisen: I want to use paru to manage
# packages as it seems more powerful than yay, but the way that yay and yeet
# work as aliases for these commands is too good to not keep.
export alias yay = paru -Syu
export alias yeet = paru -Rnsc
export alias eet = sudo pacman -Rnsc

# ------------------------------------------------------------------------------
# changing the binding of the man command to point directly to batman instead of
# man. This is to facilitate colorizing the man commands output.
# export alias man = nvim

# ------------------------------------------------------------------------------
# correctly set up the replacements for the following commands, to more sensible
# default implementations that we get in 2023
# - cat -> bat
# - grep -> rg
# - find -> fd
# - cd -> z
export alias cat = bat
export alias grep = rg
export alias find = fd

export alias cd = __zoxide_z

# ------------------------------------------------------------------------------
# add the ability to switch manpagers with an easy alias.
export def sman [
    ...pages
] {
    with-env {MANPAGER: "bat -l Manpage"} {
        man $pages
    }
}

# ------------------------------------------------------------------------------
# alias for manipulating git subtree workflow for managing nushell dependencies
export def "nutree" [] {
  git subtree $in
}

export def "nutree update" [
  name: string="nufmt",
  branch: string="main"
] {
  let path = ($nu.default-config-dir | path join "utils" "nufmt")
  let id = (["nushell" $name ] | str join "-")
  let gitdir = ($nu.default-config-dir | path join ".git")
  (git
  --work-tree $nu.default-config-dir
  --git-dir $gitdir
  subtree pull --prefix $path $id $branch)
}
