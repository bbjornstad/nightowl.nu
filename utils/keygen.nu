#!/usr/bin/env nu

def complete-genkey-ssh [] {

}
def genkey-complete-type [] {
    [ "ed25519-sk" "ed25519" "rsa" ]
}

def genkey-complete-host [] {}

def genkey-complete-username [] {
    ^users | split row " "
}

export def --env genkey-ssh [
    --type (-t): string@genkey-complete-type
    --host (-H): string@genkey-complete-host
    --username (-u): string@genkey-complete-username
    --filename_override (-f): path
    --pin-verify (-p): bool = true
    --touch-verify (-T): bool = true
    --comment (-C): string
    --use-resident (-r): bool = true
] {
    let yubikey_mapper = {
        "22522649": "ybkyA-primary",
        "19330188": "ybkyC-MASTER",
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
