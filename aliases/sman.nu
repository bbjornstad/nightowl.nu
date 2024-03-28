#!/usr/bin/env nu
# vim: set ft=nu:

# ─[ Manpager Woes ]────────────────────────────────────────────────────────

# add the ability to switch manpagers with an easy alias; helpful for when nvim
# is down and we still need to read manual pages.
export def main [
    ...pages
] {
    with-env {MANPAGER: "bat -l Manpage"} {
        man $pages
    }
}
