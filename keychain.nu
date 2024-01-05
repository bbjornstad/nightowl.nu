#!/usr/bin/env nu
# vim: set ft=nu ts=2 sts=2 shiftwidth=2 tw=80:
# -----------------------------------------------------------------------------
# This is for the keychain realization of ssh-agents...this is to prevent the
# need to keep re-adding any ssh keys on each connect.
#
# More can be read at the following link:
# https://www.funtoo.org/Funtoo:Keychain
# -----

# sets up the keychain configuration and allows some user-adjustment for the
# parameters that are used in the call to keychain.
export def --env add-keys [
    --ssh-keys (-s): list=[], # ids of ssh keys to add via keychain
    --gpg-keys (-g): list=[], # ids of gpg keys to add via keychain
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
    $keys = ($keys
        | append $ssh_keys
        | append $gpg_keys)
    (keychain
    --inherit $inheritance
    --agents ($agents | str join ",")
    --systemd
    --eval $keys)
        | lines -s
        | parse '{varname}={varval}; export {_};'
        | select varname varval
        | transpose -r
        | into record
        | load-env
}
