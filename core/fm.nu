#!/usr/bin/env nu
# vim: set ft=nu:

def nvim-background-completion [] {
    ["dark" "light"]
}

def nvim-scheme-registry-completion [] {
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

export def --wrapped edit-at [
    loc?: directory
    ...args: string # optional neovim configuration/startup flags and arguments
    --background (-b): string@nvim-background-completion
    --colorscheme (-c): string@nvim-scheme-registry-completion
] {
    let nubackground = if ($background == null) {
        $env.NIGHTOWL_BACKGROUND
    } else {
        $background
    }
    let nucolorscheme  = if ($colorscheme == null) {
        $env.NIGHTOWL_COLORSCHEME
    } else {
        $colorscheme
    }
    let location = if ($loc == null) {
        $env.HOME
    } else {
        $loc
    }
    with-env {
        PWD: $location
        NIGHTOWL_BACKGROUND: $nubackground
        NIGHTOWL_COLORSCHEME: $nucolorscheme
    } { do { nvim ...$args } | complete }
}

export module cfm {
    # edit configuration files
    export def --wrapped main [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         $env.XDG_CONFIG_HOME
         ...$args)
    }

    # edit neovim configuration files
    export def --wrapped neovim [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        let loc = (pf join-config "nvim")
        (edit-at
         $loc
         ...$args)
    }

    # edit nushell configuration files
    export def --wrapped nushell [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-config  "nushell")
         ...$args)
    }

    # edit wezterm configuration files
    export def --wrapped wez [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-config "wezterm")
         ...$args)
    }
}

export module prj {
    # work on projects
    export def --wrapped main [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "prj")
         ...$args)
    }

    # work on personal website
    export def --wrapped website [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "prj" "bjornstad.dev")
         ...$args)
   }

   # work on dotcandyd
    export def --wrapped dot [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "prj" "dotcandyd")
         ...$args)
    }

    # work on cosmic-quote
    export def --wrapped cq [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "prj" "cosmic-quote")
         ...$args)
    }

    # work on cosmic-gate
    export def --wrapped cg [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "prj" "cosmic-gate")
         ...$args)
    }

    # work on personal neovim plugins/mods
    export def --wrapped nvim-dev [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "prj" "nvim-dev")
         ...$args)

    }

    # work on ficus.nvim
    export def --wrapped ficus [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "prj" "nvim-dev" "ficus.nvim")
         ...$args)
    }

    # work on funsak.nvim
    export def --wrapped funsak [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "prj" "nvim-dev" "ficus.nvim")
         ...$args)
    }
}

export module org  {
    # edit organizational document entries
    export def --wrapped main [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "org")
         ...$args)
    }

    # edit organizational journal document entries
    export def --wrapped journal [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "org" "journal")
         ...$args)
    }

    # (edit organizational note document entries)
    export def --wrapped notes [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "org" "notes")
         ...$args)
    }

    # edit organizational email document entries
    export def --wrapped mail [
        ...args: string # optional neovim configuration/startup flags and arguments
    ] {
        (edit-at
         (pf join-home "org" "prsc" "email")
         ...$args)
    }

    # edit organizational home document entries
    export def --wrapped home [
        ...args: string # optional neovim configuration/startup flags and arguments
        --thismonth(-m)
        --subdirectory(-s): directory
    ] {
        mut pathelem = ["org" "home"]
        if not ($subdirectory | is-empty) {
            $pathelem = ($pathelem | append $subdirectory)
        }
        (edit-at
         (pf join-home ...($pathelem | compact))
         ...$args)
    }
}


export use cfm
export use prj
export use org
