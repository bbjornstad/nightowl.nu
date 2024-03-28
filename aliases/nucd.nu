#!/usr/bin/env nu
# vim: set ft=nu:

# ─[ Searching and File System Navigation ]─────────────────────────────────

# cat -> bat
# grep -> rg
# find -> fd
# cd -> z
export alias cat = bat
export alias grep = rg
export alias find = fd

export alias cd = __zoxide_z
