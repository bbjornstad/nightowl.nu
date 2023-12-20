#!/usr/bin/env nu
# vim: set ft=nu ts=2 sts=2 shiftwidth=2 tw=80:
# -----------------------------------------------------------------------------
# This is for the keychain realization of ssh-agents...this is to prevent the
# need to keep readding any ssh keys on each connect.
#
# More can be read at the following link:
# https://www.funtoo.org/Funtoo:Keychain
# -----
let gpg_keys = {
  ybkyA_primary: "837F634242488FFB"
}

# explicitly enumerate the keys used for SSH here. the format should be host:
# identity-file as a string, relative to the user ~/.ssh directory.
let ssh_keys = {
  eta: "id_ursa-eta_ybkyA-primary_ed25519-sk_ursa-amalthea",
  github: "id_bbjornstad-at-github_ybkyA-primary_ed25519-sk_ursa-amalthea",
  codeberg: "id_ursa-major-at-codeberg_ybkyA-primary_ed25519-sk_ursa-amalthea"
}

# we have to explicitly put them all together here, but this is probably
# automateable if I do it a certain way.
let keys = [ $gpg_keys.ybkyA_primary $ssh_keys.eta $ssh_keys.github $ssh_keys.codeberg ]
let agents = [ "gpg", "ssh" ]

# call the keychain executable on the command line, noting that we want to
# inherit any already-existing agents (e.g. --inherit "any-once" flag).
# Moreover, because we want to control both ssh and gpg keys with keychain, we
# start both agents if they are not already running with --agents "gpg,ssh".
# Apparently we need to put the GPG first though otherwise it gets skipped...
# Finally, we want to inject variables into SystemD for compatibility reasons,
# and we want to use the --eval flag to correctly get the information of
# initialized agents for other programs to use as needed.
#
# Most of this is directly from Keychain's own manual entries, but some of it I
# had to piece together myself.
keychain --inherit "any" --agents ($agents | str join ",")  --systemd --eval $keys
  | lines -s
  | parse '{varname}={varval}; export {extravarname}' #; export {varname};'
  | select varname varval
  | transpose -r
  | into record
  | load-env

