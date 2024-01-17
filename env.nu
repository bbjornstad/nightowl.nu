#)!/usr/bin/env nu

# ╓──────────────────────────────────────────────────────────────────────╖
# ║ Nushell Environment Config File                                      ║
# ╙──────────────────────────────────────────────────────────────────────╜
# Implemented for nightshell

# ╒══════════════════════════════════════════════════════════════════════╕
#   env.nu:
# └──────────────────────────────────────────────────────────────────────┘
#   Setting up the nushell environment: this configuration file is run BEFORE
#   the config.nu file that is adjacent to this one. This means it is possible
#   to add definitions prior to when the final config.nu file is parsed and
#   evaluated by the shell.
#
#   This file is mostly used to define environment variables using the let-env
#   syntax. Technically though, we can import other files if needed?

# ─[ Section::Prompt: ]─────────────────────────────────────────────────────
# the following section defines the commands that are used to generate the
# prompt when using nushell on the terminal
#
#   As such, adjustments can be made here.
def create_left_prompt [] {
    mut home = ""
    try {
        if $nu.os-info.name == "windows" {
            $home = $env.USERPROFILE
        } else {
            $home = $env.HOME
        }
    }

    let dir = ([
        ($env.PWD
        | str substring 0..($home | str length)
        | str replace $home "~"),
        ($env.PWD | str substring ($home | str length)..)
    ] | str join)

    let path_color = (if (is-admin) {
        ansi red_bold
    } else {
        ansi green_bold
    })
    let separator_color = (if (is-admin) {
        ansi light_red_bold
    } else {
        ansi light_green_bold
    })
    let path_segment = $"($path_color)($dir)"

    ($path_segment
    | str replace --all (char path_sep) $"($separator_color)/($path_color)")
}

def create_right_prompt [] {
    let time_segment_color = (ansi magenta)

    let time_segment = ([
        (ansi reset)
        $time_segment_color
        (date now | date format '%m/%d/%Y %r')
    ]
    | str join
    | (str replace
        --all "([/:])" $"(ansi light_magenta_bold)${1}($time_segment_color)")
    | str replace --all "([AP]M)" $"(ansi light_magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    [$last_exit_code, (char space), $time_segment] | str join
}

# ─[ Section::PromptAssignments: ]──────────────────────────────────────────
# the following assigns defined prompts to the left or right sides of the
# terminal, where the prompts are allowed to appear.
#
# In this case, we are not using any of the definitions above, and instead
# overwriting the left-prompt to use Oh-My-Posh, a framework for shell
# configuration and theming. Because Oh-My-Posh is fully-featured already, we
# don't need to assign any other prompts to the left or right sides here.
$env.PROMPT_COMMAND = {|| (
    oh-my-posh prompt print primary
    --config ~/.config/posh/prompts/ursadipt.omp.json
) }
$env.PROMPT_COMMAND_RIGHT = {|| }

# The prompt indicators are environmental variables that represent the state of
# the prompt
# overridden to allow the oh-my-posh settings to fully control the prompt
# display
$env.PROMPT_INDICATOR = {|| }
$env.PROMPT_INDICATOR_VI_INSERT = {|| }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| }
$env.PROMPT_MULTILINE_INDICATOR = {|| }

# ─[ Section::ConvertEnvironment: ]─────────────────────────────────────────
# the following section defines how nushell should "translate" environment
# variables into a nushell-compatible format. Because data types are much more
# rigid in nushell than other shells, conversions can help reduce some
# boilerplate/room for human error.
#
# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands
#   (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| ($s
        | split row (char esep)
        | path expand --no-symlink) }
        to_string: { |v| ($v
        | path expand --no-symlink
        | str join (char esep)) }
    }
    "Path": {
        from_string: { |s| ($s
        | split row (char esep)
        | path expand --no-symlink) }
        to_string: { |v| ($v
        | path expand --no-symlink
        | str join (char esep)) }
    }
}

# ─[ Section::PATH: ]───────────────────────────────────────────────────────
#   this section updates the configuration to know where to look for external
#   libraries, binaries, or scripts. In other words, directories to search for
#   scripts when calling source or use By default,
#   <nushell-config-dir>/scripts is added
let completions = ($nu.default-config-dir | path join "completions")
let core = ($nu.default-config-dir | path join "core")
let utils = ($nu.default-config-dir | path join "utils")
let share = ($nu.default-config-dir | path join "share")
let std = ($nu.default-config-dir | path join "libstd")
$env.NU_LIB_DIRS = [
    $nu.default-config-dir
]

# Directories to search for plugin binaries when calling register
# By default, <nushell-config-dir>/plugins is added
let plug_base = ($nu.default-config-dir | path join "plugins")
$env.NU_PLUGIN_DIRS = [
    $plug_base
]

# add in cargo binary directory to path to allow for cargo installed pkgs to
# show up in nushell correctly
let cargo_bin = ([ $env.HOME, ".cargo", "bin" ] | path join)
let extra_paths = [ $cargo_bin ]

$env.PATH = ($env.PATH | split row (char esep) | prepend $extra_paths)

# ─[ Section::dotcandyd ]───────────────────────────────────────────────────
# the dotcandyd systems home folder here. this is used in the nushell by default
# and for those who use this program, I would recommend it strongly.
# configuration definition of the candy cli
$env.DOTCANDYD_USER_HOME = ($env.HOME | path join ".candy.d")

# ─[ Section::zoxide ]──────────────────────────────────────────────────────
# correctly setup zoxide for nushell
zoxide init nushell | save -f ~/.config/nushell/zoxide.nu
