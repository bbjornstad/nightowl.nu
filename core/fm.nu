#!/usr/bin/env nu
# vim: set ft=nu:

def home-path [] {
    $env.HOME
}

export def join-home [...args] {
    [$env.HOME ...$args] | path join
}

def edit-at-bg-completion [] {
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

export def edit-at [
    loc?: directory
    ...args: path
    --background (-b): string@edit-at-bg-completion
    --colorscheme (-c): string@nvim-scheme-registry-completion
] {
    let nubackground = if ($background | is-empty) {
        $env.NIGHTOWL_BACKGROUND
    } else {
        $background
    }
    let nucolorscheme  = if ($colorscheme | is-empty) {
        $env.NIGHTOWL_COLORSCHEME
    } else {
        $colorscheme
    }
    cd ([(home-path) $loc] | path join); with-env {
        NIGHTOWL_BACKGROUND: $nubackground
        NIGHTOWL_COLORSCHEME: $nucolorscheme
    } { nvim ...$args }
}

export module cfm {
    export def main [
        ...args: path
        --background (-b): string@edit-at-bg-completion
        --colorscheme (-c): string@nvim-scheme-registry-completion
    ] {
        edit-at (join-path ".config") ...$args
    }
    export def neovim [
        ...args: path
    ] {
        edit-at (join-home ".config" "nvim"]) ...$args
    }
    export def nushell [
        ...args: path
    ] {
        edit-at (join-home ".config" "nushell") ...$args
    }
    export def wez [
        ...args: path
    ] {
        edit-at (join-home ".config" "wezterm") ...$args
    }
}

export module prj {
    export def main [...args: path] {
        edit-at "prj" ...$args
    }
    export def website [...args: path] {
        edit-at (["prj" "bjornstad.dev"] | path join) ...$args
         nvim ...$args
   }
    export def dot [...args: path] {
        edit-at (["prj" "dotcandyd"] | path join) ...$args
    }
    export def cq [...args: path] {
        edit-at (["prj" "cosmic-quote"] | path join) ...$args
    }
    export def cg [...args: path] {

        edit-at (["prj" "cosmic-gate"] | path join) ...$args
    }
    export def nvim-dev [...args: path] {
        edit-at (["prj" "nvim-dev"] | path join) ...$args

    }
    export def ficus [...args: path] {
        edit-at (["prj" "nvim-dev" "ficus.nvim"] | path join) ...$args
    }
    export def funsak [...args: path] {
        edit-at (["prj" "nvim-dev" "ficus.nvim"] | path join) ...$args
    }
}

export module org  {
    export def main [...args: path] {
        edit-at "org" ...$args
    }

    export def "journal" [...args: path] {
        edit-at (["org" "journal"] | path join) ...$args
    }

    export def "notes" [...args: path] {
        edit-at (["org" "notes"] | path join) ...$args
    }

    export def "mail" [...args: path] {
        edit-at (["org" "prsc" "email"] | path join) ...$args
    }

    export def "home" [
        ...args: path
        --thismonth(-m)
        --subdirectory(-s): directory
    ] {
        mut pathelem = ["org" "home"]
        if not ($subdirectory | is-empty) {
            $pathelem = ($pathelem | append $subdirectory)
        }
        edit-at ($pathelem | compact | path join) ...$args
    }
}


export use cfm
export use prj
export use org
