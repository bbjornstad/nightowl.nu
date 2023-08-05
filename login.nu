#!/usr/bin/env nu
# vim: set ft=nu ts=2 sts=2 shiftwidth=2 tw=80:

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
source ~/.config/nushell/keychain.nu

