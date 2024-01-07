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


# Nightshell: Login Configuration
# ===============================
# this file defines the behavior that nushell should inherit when the program is
# initialized. Mainly, we set up keychain in this file to minimize how much
# authentication must be completed.
#
# Section: Keychain Module
# ========================
# this is a custom module that I have created to handle the ssh-agent and
# gpg-agent processes through keychain. This must be included here so that we
# can correctly use it later.
use ~/.config/nushell/keychain.nu add-keys

const ssh_keys = {
    eta: "id_ursa-eta_ybkyA-primary_ed25519-sk_ursa-amalthea",
    github: "id_bbjornstad-at-github_ybkyA-primary_ed25519-sk_ursa-amalthea",
    codeberg: "id_ursa-major-at-codeberg_ybkyA-primary_ed25519-sk_ursa-amalthea"
}

const gpg_keys = {
    passwordstore: "D67D6455A0382752"
    ybkyA_primary: "8361328584A414FE"
}

(add-keys
    --ssh-keys ($ssh_keys | values)
    --gpg-keys ($gpg_keys | values)
    --inheritance "any-once")
