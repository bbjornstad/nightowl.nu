#!/usr/bin/env nu
# vim: set ft=nu:

# ─[ File Managers ]────────────────────────────────────────────────────────

# aliases for nnn with the correct environment variables, presumably this was to
# allow nnn preview to work correctly.
export alias nnn = with-env { MANPAGER: bat } { nnn }
