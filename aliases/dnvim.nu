#!/usr/bin/env nu
# vim: set ft=nu:

# ─[ Neovim Aliases ]───────────────────────────────────────────────────────

# use of vim on the command line will actually invoke nvim instead. Also set up
# two aliases to adjust the background color if desired.
export def --wrapped main [ ...args ] {
    with-env { NIGHTOWL_BACKGROUND_STYLE: "dark" } {
        ^nvim ...$args
    }
}

export def --wrapped lnvim [ ...args ] {
    with-env { NIGHTOWL_BACKGROUND_STYLE: "light" } {
        ^nvim ...$args
    }
}

export def --wrapped rockvim [...args] {
    with-env { NVIM_APPNAME: "nvim-rocks" } {
        ^nvim ...$args
    }
}
