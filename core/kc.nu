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


# ╓──────────────────────────────────────────────────────────────────────╖
# ║ Nightshell Keychain Manager:                                         ║
# ╙──────────────────────────────────────────────────────────────────────╜
# ============================
# a simple tool to add SSH and GPG keys to the session keychain, so that the
# credentials can be cached safely and reliably without needing the user to
# validate so frequently. This is largely informed by experiences making Yubikey
# hardware security tokens work with nushell, but should hold even for
# non-hardware backed keys. Uses `keychain` as a backend driver for GPG and SSH
# agents.
#
# More can be read at the following link:
# https://www.funtoo.org/Funtoo:Keychain
# -----

# sets up the keychain configuration and allows some user-adjustment for the
# parameters that are used in the call to keychain.

export def --env add-keys [
    --ssh-keys (-s): list<string> # ids of ssh keys to add via keychain
    --gpg-keys (-g): list<string> # ids of gpg keys to add via keychain
    --inheritance (-i): string="any-once" # inherits behavior for keychain
] {
    mut agents = []
    mut keys = []

    if not ($ssh_keys | is-empty) {
        $agents = ($agents | append "ssh")
    }
    if not ($gpg_keys | is-empty) {
        $agents = ($agents | append "gpg")
    }
    $keys = $keys
        | append $ssh_keys
        | append $gpg_keys

    (keychain
     --inherit $inheritance
     --agents ($agents | str join ",")
     --systemd
     --eval ...$ssh_keys ...$gpg_keys)
    | lines -s
    | parse '{varname}={varval}; export {_};'
    | select varname varval
    | transpose -r
    | into record
    | load-env
}
