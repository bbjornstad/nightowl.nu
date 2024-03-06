#!/usr/bin/env nu
# vim: set ft=nu:

# raur: Paru Wrapper

module raur {
    export def main [] { }

    export def "remove" [] {
        (^paru -Qq
         | ^fzf --multi --preview 'paru -Qi {1}'
         | ^xargs -ro sudo paru -Rnsc)
    }

    export def "install" [] {
        (^paru -Slq
         | ^fzf --multi --preview 'paru -Si {1}'
         | ^xargs -ro paru -Syu)
    }
}

export use raur
