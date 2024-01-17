#!/usr/bin/env nu
# vim: set ft=nu:

export def main [] {

}

export def "rsh new" [] {

}

export def "rsh list" [] {

}

export def "rsh clean" [] {

}

export extern zellij [
    --config (-c): path
    --config-dir: path
    --debug (-d)
    --data-dir: directory
    --help (-h)
    --layout (-l): string
    --max-panes: int
    --session (-s): string
    --version (-v)
]
