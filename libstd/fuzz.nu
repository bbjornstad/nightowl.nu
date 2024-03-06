export extern fzf [
    ...args: path
]

export module fz {
    export def --wrapped main [
        input: closure
        output: closure
        ...fzf_args: string
    ] {
        do $input | ^fzf ...$fzf_args | do $output
    }
}

export use fz *
