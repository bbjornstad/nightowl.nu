#!/usr/bin/env nu
# vim: set ft=nu:
def home-path [] {
    $env.HOME
}

def join-home [...args] {
    [$env.HOME ...$args] | path join
}

def edit-at-completion-bg [] {
    ["dark", "light"]
}

export def edit-at [
    loc?: directory
    ...args: path
    --background (-b): string@edit-at-completion-bg
    --colorscheme (-c): string="kanagawa"
] {
    cd ([(home-path) $loc] | path join | inspect); with-env {
        NIGHTOWL_BACKGROUND: $background,
        NIGHTOWL_COLORSCHEME: $colorscheme
    } { nvim ...$args }
}

# the fabled neovim
export extern nvim [
    ...args: path       # file arguments to open nvim
    -t: string          # [tag]: a tag, looked up in tags file and the match is chosen.
    -q: path            # [errorfile]: open in quickfix mode with the name of an errorfile
    --cmd: string       # [cmd]: Execute <cmd> before any config
    -c: string          # [cmd]: Execute <cmd> after config and first file
    -l:  string         # [script]: Execute Lua <script> (with optional args)
    -S: string          # [session]: Source <session> after loading the first file
    -s: string          # [scriptin]: Read Normal mode commands from <scriptin>
    -u: path            # [cfgfile]: Use config [cfgfile]
    -d                  # Diff mode
    --es                # Silent (batch) mode
    --help (-h)         # Print this help message
    -i: path            # [shada]: Use shada file [shada]
    -n                  # No swap file, use memory only
    -o: int             # [N]: Open N windows (default: one per file)
    -O: int             # [N]: Open N vertical windows (default: one per file)
    -p: int             # [N]: Open N tab pages (default: one per file)
    -R                  # Read-only (view) mode
    --version (-v)      # Print version information
    -V: int             # [level]: Verbose [level]
    --api-info          # Write msgpack-encoded API metadata to stdout
    --clean             # "Factory defaults" (skip user config and plugins, shada)
    --embed             # Use stdin/stdout as a msgpack-rpc channel
    --headless          # Don't start a user interface
    --listen: string    # [address]: Serve RPC API from [address]
    --remote            # Execute commands remotely on a server
    --server: string    # [server]: Specify RPC [server] to send commands to
    --startuptime: path # [file]: Write startup timing messages to [file]
]

export module cfm {
    export def main [
        ...args: path
        --background (-b): string@edit-at-completion-bg
        --colorscheme (-c): string
    ] {
        edit-at (join-path ".config") ...$args
    }
    export def neovim [
        ...args: path
    ] {
        edit-at (join-home ".config" "nvim"]) ...$args
    }
    export def nushell [
        ...args: path
    ] {
        edit-at (join-home ".config" "nushell") ...$args
    }
    export def wez [
        ...args: path
    ] {
        edit-at (join-home ".config" "wezterm") ...$args
    }
}

export module prj {
    export def main [...args: path] {
        edit-at "prj" ...$args
    }
    export def website [...args: path] {
        edit-at (["prj" "bjornstad.dev"] | path join) ...$args
         nvim ...$args
   }
    export def dot [...args: path] {
        edit-at (["prj" "dotcandyd"] | path join) ...$args
    }
    export def org [...args: path] {
        edit-at "org" ...$args
    }
    export def cq [...args: path] {
        edit-at (["prj" "cosmic-quote"] | path join) ...$args
    }
    export def cg [...args: path] {

        edit-at (["prj" "cosmic-gate"] | path join) ...$args
    }
    export def nvim-dev [...args: path] {
        edit-at (["prj" "nvim-dev"] | path join) ...$args

    }
    export def ficus [...args: path] {
        edit-at (["prj" "nvim-dev" "ficus.nvim"] | path join) ...$args
    }
    export def funsak [...args: path] {
        edit-at (["prj" "nvim-dev" "ficus.nvim"] | path join) ...$args
    }
}

export use cfm
export use prj
