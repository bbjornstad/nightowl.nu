#!/usr/bin/env nu
# vim: set ft=nu ts=2 sts=2 shiftwidth=2 tw=80:

# ------------------------------------------------------------------------------
# Testing Something:
# -----
# A necessary step for most GPG enabled workflows is to make sure that the
# GPG_TTY environment variable is set correctly to the current tty. This should
# occur before the need for any gpg-agent, and therefore should maybe go right
# here? directly before? the only thing is this is login.nu...might present
# issues?
# $env.GPG_TTY = (tty)

# ------------------------------------------------------------------------------
# Login.nu
#     this file defines the behavior that nushell should inherit when the
#     program is initialized.
#     Mainly, we set up keychain in this file to minimize how much
#     authentication must be completed. Keychain, as a program, is pretty good
#     at handling secrets/new environment configurations on the fly. Maybe that
#     is a reasonable place to look around at in order to glean some more
#     information.
#
# More can be read at the following link:
# https://www.funtoo.org/Funtoo:Keychain
# -----
# source ~/.config/nushell/keychain.nu

# ==============================================================================
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
