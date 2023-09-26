#!/usr/bin/env nu
# vim: set ft=nu ts=2 sts=2 sw=2 et:

export def-env yubikey-env [
  mask: list

] {

}

def complete-genkey-ssh [] {

}
def "complete-genkey-ssh type" [] {
  [ "ed25519-sk" "ed25519" "rsa" ]
}

def "complete-genkey-ssh host" [] {

}

def "complete-genkey-ssh username" [] {
  ^users
}

export def-env genkey-ssh [
  --type? (-t): string@(complete-genkey-ssh type),
  --host? (-H): string@(complete-genkey-ssh host),
  --username? (-u): string@(complete-genkey-ssh username),
  --filename_override? (-f): path,
  --pin-verify (-p): bool = true,
  --touch-verify (-T): bool = true,
  --comment (-C)?: string,
  --use-resident (-r): bool = true,
] {
  let yubikey_mapper = {
    "22522649": "ybkyA-primary",
    "19330188": "ybkyC-primary",
  }
  let yubikeys = (ykman list
                  | lines -s
                  | parse '{keydesc} Serial: {Serial}'
                  | inspect
                  | select Serial
                  | insert YubikeyName yubikey_mapper.(get Serial)
                  | inspect)

  let appstr = $"application=ssh:id_($yubi_name).($type).($username)@($host)-($env.HOSTNAME)"
  let appusr = $"user=($username)"
  let gencmd = $"^ssh-keygen -t ($type) -O resident -O ($appusr) -O ($appstr) -C ($comment)"
  nu -c $gencmd
}

