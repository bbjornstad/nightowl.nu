#!/usr/bin/env nu
# vim: set ft=nu:

# ─[ Neovim Aliases ]───────────────────────────────────────────────────────

# use of vim on the command line will actually invoke nvim instead. Also set up
# two aliases to adjust the background color if desired.
export def main [ ...args ] {
    with-env { NIGHTOWL_BACKGROUND_STYLE: "dark" } {
        nvim ...$args
    }
}
export def lnvim [ ...args ] {
    with-env { NIGHTOWL_BACKGROUND_STYLE: "light" } {
        nvim ...$args
    }
}
