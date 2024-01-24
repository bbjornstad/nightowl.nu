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

export extern keychain [
    ...keys: string
    --agents: string              # credential agents that are targeted, can be either ssh or gpg or a list containing both of these separated with a comma
    --attempts: int               # how many attempts to try before failing to perform action on a key
    --clear                       # clear out all of the existing keys registered to the targeted agents; typically part of .bash_profile
    --confhost                    # search the SSH configuration file for configured SSH hosts and add them automatically
    --confirm                     # key additions are subject to interactive confirmation
    --absolute                    # arguments to `dir` are taken as absolutes even if the syntax would otherwise indicate something different
    --dir: directory              # set default application directory instead of the default "$HOME/.keychain"
    --query                       # prints results such that only valid environment variable setting statements are allowed
    --eval                        # prints results such that the target shell can directly use the output to instantiate keychain
    --env: path                   # a file containing alternative environment specifications.
    --gpg2                        # on systems with both gpg and gpg2, use this flag to control which version is being used by the keychain backend.
    --help (-h)                   # display command help
    --host: string                # creation of pidfiles will use this hostname instead of the default system-level hostname
    --ignore-missing              # skip any keys that are missing instead of erroring out.
    --inherit string="local-once" # set behavior of the keychain instance to one of the valid options (`local`, `local-once`, `any`, `any-once`); see `man keychain`
    --list (-l)                   # list registered keys for this keychain
    --list-fp (-L)                # list registered keys with associated fingerprint
    --lockwait: int               # number of seconds to wait to gain lock on card-related mishaps
    --noask                       # do not ask for confirmation
    --nocolor                     # print output without color
    --nogui                       # assume that there is no gui present, effectively overriding pinentry settings
    --noinherit                   # do not inherit any behavior from a possible parent.
    --nolock                      # do not attempt to gain an exclusive lock before executing
    --stop (-k): string           # stop the targeted keychain instances elsewhere
    --systemd                     # inject variables into systemd environment
    --quick (-Q)                  # minimize input validation and multi-instance lockchecking; has some caveats
    --quiet (-q)                  # minimize tui output
    --timeout: int                # specifies a timeout in number of minutes for the keys added to this isntance of keychain
    --version (-V)                # show version information
]

export def main [
    --agents (-a): list<string>
    --fp (-f)
] {
    if ($fp | is-empty) {
        ^keychain --agents ($agents | str join ",") --list
    } else {
        ^keychain --agents ($agents | str join ",") --list-fp
    }
}

export def --env add [
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

    (^keychain
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
