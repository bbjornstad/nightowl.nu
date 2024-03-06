#!/usr/bin/env nu
# vim: set ft=nu:

# initializes weechat behind a call to `do` which will capture any errors or
# output. This solves a problem wherein the weechat instance gets continuously
# interrupted by the pinentry on gpg and my yubikey
export def chat [] {
    do --capture-errors { || weechat  }
}
