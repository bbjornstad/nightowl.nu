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
        ...args: string
        --mount-root: directory
        --lukstype: string@'completes cryptsetup-types'
        --keyparam: record
    ] {
        (decrypt
         --lukstype=$lukstype
         --mount-root=$mount_root
         --keyparam=$keyparam
         $disk $name ...$args)
    }

    export def --wrapped decrypt [
        disk: string
        name: string
        ...args: string
        --keyparam: record
        --lukstype: string@'completes cryptsetup-types'
    ] {
        # parse out the required parameters and assign sensible defaults if none
        # are given
        let luks_type = $lukstype | default "luks2"

        let keyfile = $keyparam | get "file"
        let keypass = $keyparam | get "pass"

        ^sudo cryptsetup --type=$lukstype ...$args open $disk $name
    }

    export def bind [
        disk: string
        name: string
        --mount-root: directory
    ] {
        let mount_point = $mount_root | default $"/mnt/($name)"

        ^sudo mount --mkdir (["dev", "mapper" $name] | path join) $mount_point
    }

    export def --wrapped drive [
        disk: string
        name: string
        ...args: string
        --mount-root: directory
        --no-unlock
        --lukstype: string@'completes cryptsetup-types'
        --keyparam: record
    ] {
        decrypt $disk $name ...$args --keyparam=$keyparam --lukstype=$lukstype
        if $mount_root != null {
            # if a matching root mounting point is found, then mount the disk
            # accordingly
            ^sudo mount --mkdir $"/dev/mapper/($name)" $mount_root
        }
    }

    export def callisto [
        name: string = 'callisto.rsx'
        --cryptsetup-keys-dir: directory='/etc/cryptsetup-keys.d'
    ] {
        let DEVUUID = '2d6b47a9-ade0-4678-bb05-e482d0251457'
        let DEVID = ^blkid --uuid $DEVUUID

        let keyname = [$name 'crypt.key'] | str join "."
        let mntname = [$name 'dcrypt'] | str join "."
        let keyfile = [$cryptsetup_keys_dir $keyname] | path join

        let keypar = {
            file: $keyfile
        }

        drive --lukstype='luks2' --keyparam=$keypar $DEVID $mntname
    }

}
