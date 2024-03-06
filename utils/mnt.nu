#!/usr/bin/env nu
# vim: set ft=nu:

module completes {
    export def main [] {}
    export def cryptsetup-types [] {
        [ "luks", "luks2", "_luks", "plain" ]
    }
}

use completes

module mnt {
    export def --wrapped main [
        disk: path
        name: string
        --pmap: directory
        --lukstype: string@'completes cryptsetup-types'
        --keyparam: record
        ...args: string
    ] {
        call-main --lukstype $lukstype --keyparam $keyparam $disk --pmap $pmap $name ...$args
    }

    def --wrapped call-main [
        disk: path
        name: string
        --pmap: directory
        --lukstype: string@'completes cryptsetup-types'
        --keyparam: record
        ...args: string
    ] {
        sudo cryptsetup --type $lukstype open $disk ...$args
        if not ($pmap == null) {
            # do something
            print "asdf"
        } else {
            sudo mount --mkdir $"/dev/mapper/($name)" $pmap
        }
    }

    export def callisto [] {
        let keypar = {file: '/etc/cryptsetup-keys.d/callisto.rsx.crypt.key'}
    }

}
