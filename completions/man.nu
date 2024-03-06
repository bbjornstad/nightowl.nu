#!/usr/bin/env nu
# vim: set ft=nu:

def "nu-complete manpages"  [] {
    (^man -w
     | str trim
     | split row (char esep)
     | par-each { glob $'($in)/man?' }
     | flatten
     | par-each { ls $in | get name }
     | flatten
     | path basename
     | str replace ".gz" "")
}

export extern main [
    ...targets: string@'nu-complete manpages'
]
