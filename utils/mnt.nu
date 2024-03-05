#!/usr/bin/env nu
# vim: set ft=nu:

def cryptsetup-types [] {
    [ "luks", "luks2", "_luks", "plain" ]
}

export def --wrapped main [
    disk: path
    mountpoint: directory,
    --lukstype: string@cryptsetup-types,
    --keyparam: record
] {
    sudo cryptsetup --type $lukstype --
}

export def "main callisto" [] {

}
