#!/usr/bin/env nu
# vim: set ft=nu:

module schemaphore {
    export def sc [] {}

    export def "scheme to-env" [] {

    }

    export def --env scheme [] {
        let color = $env.URSA_COLORSCHEME
        let wez_scheme = ($color | component --names ["nvim", "wezterm", "zellij", "nushell"])
    }

    export def component [
        colors?: string
        --names: list<string>
    ] {
        let fcol = $colors | default $in
    }
}
