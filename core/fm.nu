#!/usr/bin/env nu
# vim: set ft=nu:

module completes {
    export def nvim-background [] {
        ["dark" "light"]
    }

    export def nvim-scheme-registry [] {
        [
            "kanagawa"
            "deepwhite"
            "nano-theme"
            "nightfox"
            "dawnfox"
            "nightcity-afterlife"
            "rose-pine"
            "newpaper"
        ]
    }

    export def edit-prj [] {
        let loc = pf join-home "prj"
        glob ([$loc "*"] | path join)
    }

    export def edit-cfm [] {
        let loc = $env.XDG_CONFIG_HOME
        glob ([$loc "*"] | path join)
    }

    export def edit-org [] {
        let loc = pf join-home "org"
        glob ([$loc "*"] | path join)
    }
}

use completes

# technically, this is not needed as the supermodule is already included in
# nushell's library paths. But without having such definitions available, this
# breaks compatibility with other systems or nushell installations.
use libstd/pf.nu

export def --wrapped edit-at [
    ...args: string # optional neovim configuration/startup flags and arguments
    --background (-b): string@'completes nvim-background'
    --colorscheme (-c): string@'completes nvim-scheme-registry'
]: [directory -> nothing, list<directory> -> nothing, nothing -> nothing] {
    let loc = $in
    let nubackground = $background | default $env.NIGHTOWL_BACKGROUND
    let nucolorscheme  = $colorscheme | default $env.NIGHTOWL_COLORSCHEME
    let location = $loc | default $env.HOME
    with-env {
        PWD: $location
        NIGHTOWL_BACKGROUND: $nubackground
        NIGHTOWL_COLORSCHEME: $nucolorscheme
    } { $loc | do { || ^nvim $in ...$args } | complete }
}

export module cfm {
    def --wrapped edit-cfm [
        loc?: path@'completes edit-cfm'
        ...args: string
    ]: [directory -> nothing, list<directory> -> nothing, nothing -> nothing] {
        let nuloc = pf join-config ($loc | default "")
        $nuloc | edit-at ...$args
    }

    # edit configuration files
    export def --wrapped main [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-cfm ...$args
    }

    # edit neovim configuration files
    export def --wrapped neovim [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-cfm "nvim"...$args
    }

    # edit nushell configuration files
    export def --wrapped nushell [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-cfm "nushell" ...$args
    }

    # edit wezterm configuration files
    export def --wrapped wez [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-cfm "wezterm" ...$args
    }

    export def --wrapped zellij [
        ...args: string
    ] {
        edit-cfm "zellij" ...$args
    }
}

export module prj {
    def --wrapped edit-prj [
        loc?: path@'completes edit-prj'
        ...args: string
    ]: [directory -> nothing, list<directory> -> nothing, nothing -> nothing] {
        let nuloc = pf join-home "prj" ($loc | default "")
        edit-at $nuloc ...$args
    }

    # work on projects
    export def --wrapped main [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        let loc = pf join-home "prj"
        edit-at $loc ...$args
    }

    # work on personal website
    export def --wrapped website [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-prj "bjornstad.dev" ...$args
   }

   # work on dotcandyd
    export def --wrapped dot [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-prj "dotcandyd" ...$args
    }

    # work on cosmic-quote
    export def --wrapped cq [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-prj "cosmic-quote" ...$args
    }

    # work on cosmic-gate
    export def --wrapped cg [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-prj "cosmic-gate" ...$args
    }

    # work on personal neovim plugins/mods
    export def --wrapped nvim-dev [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-prj "nvim-dev" ...$args
    }

    # work on ficus.nvim
    export def --wrapped ficus [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-prj "nvim-dev" "ficus.nvim" ...$args
    }

    # work on funsak.nvim
    export def --wrapped funsak [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-prj "nvim-dev" "funsak.nvim" ...$args
    }
}

export module org  {
    def --wrapped edit-org [
        loc?: path@'completes edit-org'
        ...args: string
    ] {
        let nuloc = pf join-home "org" ($loc | default "")
        edit-at $nuloc ...$args
    }

    # edit organizational document entries
    export def --wrapped main [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        edit-org ...$args
    }

    # edit organizational journal document entries
    export def --wrapped journal [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
         edit-org "journal" ...$args
    }

    # (edit organizational note document entries)
    export def --wrapped notes [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
         edit-org "notes" ...$args
    }

    # edit organizational email document entries
    export def --wrapped mail [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
         edit-org "prsc" "email" ...$args
    }

    # edit organizational home document entries
    export def --wrapped home [
        ...args: string # optional neovim configuration/startup flags and arguments
        --thismonth(-m)
        --subdirectory(-s): directory
    ] {
        mut pathelem = ["org" "home"]
        if not ($subdirectory | is-empty) {
            $pathelem = $pathelem | append $subdirectory
        }
        edit-org ...($pathelem | compact) ...$args
    }
}

export use cfm
export use prj
export use org
