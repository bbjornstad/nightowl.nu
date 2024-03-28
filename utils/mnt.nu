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
        (call-main
         --lukstype $lukstype
         --pmap $pmap
         --keyparam $keyparam
         $disk $name ...$args)
    }

    def --wrapped call-main [
        disk: string
        name: string
        --pmap: directory
        --lukstype: string@'completes cryptsetup-types'
        --keyparam: record
        ...args: string
    ] {
        (^sudo cryptsetup --type $lukstype open $disk ...$args $name)
        if not ($pmap == null) {
            # do something
            print "asdf"
        } else {
            (^sudo mount --mkdir $"/dev/mapper/($name)" $pmap)
        }
    }

    export def callisto [
        name: string='callisto.rsx.dcrypt'
    ] {
        let DEVUUID = '2d6b47a9-ade0-4678-bb05-e482d0251457'
        let DEVID = (blkid --uuid $DEVUUID)

        let keypar = {file: (['etc' 'cryptsetup-keys.d'
                'callisto.rsx.crypt.key'] | path join) }

        (call-main --lukstype luks2 --keyparam $keypar $disk $name)
    }

}
