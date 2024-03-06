#!/usr/bin/env nu
# vim: set ft=nu:

# `pf`: pathfinding module for path manipulation and search

# joins path elements given as function arguments to the user's configured home
# directory.
export def join-home [
    ...args: path # additional path elements to join
] {
    $args | path join $env.HOME ...$in
}

# joins path elements given as function arguments to the user's configured
# configuration directory as a part of XDG specification.
export def join-config [
    ...args: path # additional path elements to join
] {
    $args | path join $env.XDG_CONFIG_HOME ...$in
}
