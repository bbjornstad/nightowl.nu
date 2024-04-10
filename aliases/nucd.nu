#!/usr/bin/env nu
# vim: set ft=nu:

# ─[ Searching and File System Navigation ]─────────────────────────────────

# cat -> bat
# grep -> rg
# find -> fd
# cd -> z
export def --wrapped cat [...args] {
    bat ...$args
}
export def --wrapped grep [...args] {
    rg ...$args
}
export def --wrapped find [...args] {
    fd ...$args
}

export alias cd = __zoxide_z
