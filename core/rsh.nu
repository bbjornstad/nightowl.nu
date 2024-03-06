#!/usr/bin/env nu
# vim: set ft=nu:

export def --wrapped main [
    ...args
] {
    # rsh new ...$args
}

export def --wrapped "rsh new" [
    name: string='$"rsh-(^date -I)-(random chars --length 5)"'
    ...args: string
] {
    mut fmtname = ([$name 'to nuon'] | str join " | ")
    $fmtname = (nu -c $fmtname | from nuon)
    ($fmtname | zellij attach --create ...$args $in)
}

export def --wrapped "rsh id" [
    ...args: string
] {
    zellij ls
}

export def --wrapped "rsh list" [
    ...args: string
] {
    zellij list-sessions ...$args
}

export def --wrapped "rsh del" [
    session: string
    ...args: string
    --kill
] {
    if $kill {
        zellij kill-session ...$args $session
    }
    zellij delete-session ...$args $session
}

export def --wrapped "rsh clean" [
    ...args: string
    --kill
] {
    if $kill {
        zellij kill-all-sessions ...$args
    }
    zellij delete-all-sessions ...$args
}

export def --wrapped "rsh plug" [
    ...args: string
] {
    zellij plugin ...$args
}

export def --wrapped "rsh run" [
    ...args: string
] {
    zellij run ...$args
}
