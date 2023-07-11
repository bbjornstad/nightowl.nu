# vim: set ft=nu ts=2 sts=2 shiftwidth=2 tw=80:
#!/usr/bin/env nu
# -----------------------------------------------------------------------------
# This is for the keychain realization of ssh-agents...this is to prevent the
# need to keep readding any ssh keys on each connect.
#
# More can be read at the following link:
# https://www.funtoo.org/Funtoo:Keychain
# -----------------------------------------------------------------------------
let ssh_keys = [
  "id_ursa-eta_ybkyA-primary_ed25519-sk_ursa-amalthea-rsp"
  "id_bbjornstad-at-github_ybkyA-primary_ed25519-sk_ursa-major-at-ursa-amalthea-rsp"
  "id_ursa-major-at-codeberg_ybkyA-primary_ed25519-sk_ursa-major-at-ursa-amalthea-rsp"
]
# let stringschema = "id_USERID-at-SERVICE_YUBIDESIGNATION_KEYTYPE_SOURCEID"
keychain --quiet --query --agents ssh,gpg --confhost --systemd --inherit "local-once" | (lines -s
| parse '{varname}={varval}' | transpose -i -r -d | load-env)
$ssh_keys | each { |key| keychain --quiet --systemd --inherit "local-once" $key }

