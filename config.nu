#!/usr/bin/env nu

#SPDX-FileCopyrightText: 2024 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
#SPDX-License-Identifier: MIT

#MIT License

# Copyright (c) 2024 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

#Permission is hereby granted, free of charge, to any person obtaining a copy of
#this software and associated documentation files (the "Software"), to deal in
#the Software without restriction, including without limitation the rights to
#use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
#of the Software, and to permit persons to whom the Software is furnished to do
#so, subject to the following conditions:

#The above copyright notice and this permission notice (including the next
#paragraph) shall be included in all copies or substantial portions of the
#Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

# ╓──────────────────────────────────────────────────────────────────────╖
# ║ * Nushell Configuration *                                            ║
# ╙──────────────────────────────────────────────────────────────────────╜
# * nushell is a modern shell, written in Rust for speed, safety, and
#   efficiency, and designed from the ground-up to make moving data around and
#   between shell commands in a straightforward process
# * This configuration file has most of the parameters that adjust behavior or
#   experience using nushell. However, one should prefer separate nu files that
#   are sourced here to create the final config,
# * Each section below defines a particular configuration for the nushell. It
#   should be noted that I use nushell as a login shell, which has some
#   important implications to consider. That setting is not specified here,
#   though, as it must set within the system-configuration files, not nushell,
#   e.g. by using `chsh` or `usermod` to adjust the user's shell preferences.
#   The biggest issue with nushell is that it is (obviously) not
#   POSIX-compliant, and hence some commands might have unexpected behavior, if
#   they were expecting such compliance. This is somewhat uncommon, but easy to
#   solve or convert the expected command into something compatible with
#   nushell.

# ╓                                                                      ╖
# ║ ** Section::Themes **                                                ║
# ╙                                                                      ╜
# This section defines the possible selections of theme that can be used
# nushell. Mostly, we use a dark theme for consistency across applications and
# to keep eye-strain down, but these are just the default themes given by
# nushell and includes a light version too.
#
# It should be noted that these themes namely define the coloration behavior
# with respect to things that should be colored in the terminal, but does not
# set the actual color values themselves, as those are instead handled with
# Wezterm. Unless you specifically set the theme using environment variables.
#
# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes

# ─[ custom theme directory ]───────────────────────────────────────────────

let custom_themes = ([$nu.default-config-dir "themes"] | path join)


# ─[ basic themes ]─────────────────────────────────────────────────────────

# these themes are useable across different terminal color schemes, without
# needing to make any adjustments on the fly.
let dark_theme = {
    # color for nushell primitives
    separator: white
    # no fg, no bg, attr none effectively turns this off $env.NU_L
    leading_trailing_space_bg: { attr: n }
    header: green_bold
    empty: blue
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    bool: {|| if $in { 'light_cyan' } else { 'light_gray' } }
    int: white
    filesize: {|e|
        if $e == 0b {
            'white'
        } else if $e < 1mb {
            'cyan'
        } else { 'blue' }
    }
    duration: white
    date: {|| (date now) - $in |
        if $in < 1hr {
            'purple'
        } else if $in < 6hr {
            'red'
        } else if $in < 1day {
            'yellow'
        } else if $in < 3day {
            'green'
        } else if $in < 1wk {
            'light_green'
        } else if $in < 6wk {
            'cyan'
        } else if $in < 52wk {
            'blue'
        } else { 'dark_gray' }
    }
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cellpath: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: {bg: cyan fg: light_cyan }

    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: light_red bg: red attr: b}
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
}

let light_theme = {
    # color for nushell primitives
    separator: dark_gray
    # no fg, no bg, attr none effectively turns this off
    leading_trailing_space_bg: { attr: n }
    header: green_bold
    empty: blue
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    bool: {|| if $in { 'dark_cyan' } else { 'dark_gray' } }
    int: dark_gray
    filesize: {|e|
        if $e == 0b {
            'dark_gray'
        } else if $e < 1mb {
            'cyan_bold'
        } else { 'blue_bold' }
    }
    duration: dark_gray
    date: {|| (date now) - $in |
        if $in < 1hr {
            'purple'
        } else if $in < 6hr {
            'red'
        } else if $in < 1day {
            'yellow'
        } else if $in < 3day {
            'green'
        } else if $in < 1wk {
            'light_green'
        } else if $in < 6wk {
            'cyan'
        } else if $in < 52wk {
            'blue'
        } else { 'dark_gray' }
    }
    range: dark_gray
    float: dark_gray
    string: dark_gray
    nothing: dark_gray
    binary: dark_gray
    cellpath: dark_gray
    row_index: green_bold
    record: foreground
    list: foreground
    block: foreground
    hints: dark_gray
    search_result: {fg: light_cyan bg: cyan}

    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: foreground bg: red attr: b}
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
}

# ─[ custom completers ]────────────────────────────────────────────────────

let fish_completer = {|spans: list<string>|
    fish --command $'complete "--do-complete=(...$spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}

let carapace_completer = { |spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in
        | default []
        | where value == $"($spans | last)ERR"
        | is-empty) { $in } else { null }
}

let external_completer = { |spans: list<string>|
    # if the current command is an alias, get it's expansion
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0
    | get -i expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        nu => $fish_completer
        git => $fish_completer
        asdf => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}


# ╓                                                                      ╖
# ║ Section: Main User Configuration                                     ║
# ╙                                                                      ╜

# this is the meat and potatoes of nushell, all configuration is ultimately
# needed to hook into this step in order to get caught by the nushell init
# process.
$env.config = {
    # true or false to enable or disable the welcome banner at startup
    show_banner: false
    ls: {
        # use the LS_COLORS environment variable to colorize output
        use_ls_colors: true
        # enable or disable clickable links. Your terminal has to support links.
        clickable_links: true
    }
    rm: {
        # always act as if -t was given. Can be overridden with -p
        always_trash: true
    }
    table: {
        # basic, compact, compact_double, light, thin, with_love, rounded,
        # reinforced, heavy, none, other
        mode: compact
        # "always" show indexes, "never" show indexes, "auto" = show indexes
        # when a table has "index" column
        index_mode: auto
        # show 'empty list' and 'empty record' placeholders for command output
        show_empty: true
        trim: {
            # wrapping or truncating
            methodology: wrapping
            # A strategy used by the 'wrapping' methodology
            wrapping_try_keep_words: true
            # A suffix used by the 'truncating' methodology
            truncating_suffix: "..."
        }
    }

    explore: {
        help_banner: true
        exit_esc: false

        command_bar_text: 'foreground'

        status_bar_background: {fg: 'background' bg: 'foreground' }

        highlight: {bg: 'yellow' fg: 'black' }

        status: {
            warn: { fg: 'yellow'}
            error: { fg: 'red'}
            info: { fg: 'light_blue'}
        }

        try: {
            # border_color: 'red'
            # highlighted_color: 'blue'

            # reactive: false
        }

        table: {
            split_line: dark_gray

            cursor: true

            line_index: true
            line_shift: true
            line_head_top: true
            line_head_bottom: true

            show_head: true
            show_index: true

            selected_cell: {fg: 'foreground', bg: '#777777'}
            selected_row: {fg: 'yellow', bg: '#C1C2A3'}
            selected_column: blue

            padding_column_right: 2
            padding_column_left: 2

            padding_index_left: 2
            padding_index_right: 1
        }

        config: {
            # cursor_color: {bg: 'yellow' fg: 'black' }

            # border_color: white
            # list_color: green
        }
    }

    history: {
        # Session has to be reloaded for this to take effect
        max_size: 10000
        sync_on_enter: true
        # Enable to share history between multiple sessions, else you have to
        # close the session to write history to file
        file_format: "sqlite"
        # "sqlite" or "plaintext"
        isolation: true
        # true enables history isolation, false disables it. true will allow the
        # history to be isolated to the current session. false will allow the
        # history to be shared across all sessions.
    }
    completions: {
        # set to true to enable case-sensitive completions
        case_sensitive: true
        # set this to false to prevent auto-selecting completions when only one
        # remains
        quick: true
        # set this to false to prevent partial filling of the prompt
        partial: true
        # prefix or fuzzy
        algorithm: "fuzzy"
        external: {
            # set to false to prevent nushell looking into $env.PATH to find
            # more suggestions, `false` recommended for WSL users as this look
            # up my be very slow
            enable: true
            # setting it lower can improve completion performance at the cost of
            # omitting some options
            max_results: 100
            # see above carapace completer
            completer: $external_completer
        }
    }
    filesize: {
        # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows
        # standard)
        metric: true
        # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
        format: "auto"
    }
    cursor_shape: {
        # block, underscore, line, blink_block, blink_underscore, blink_line
        # (line is the default)
        emacs: blink_line
        # block, underscore, line , blink_block, blink_underscore, blink_line
        # (block is the default)
        vi_insert: blink_line
        # block, underscore, line, blink_block, blink_underscore, blink_line
        # (underscore is the default)
        vi_normal: blink_underscore
    }
    # if you want a light theme, replace `$dark_theme` to `$light_theme`
    color_config: $light_theme,
    use_grid_icons: true
    # always, never, number_of_rows, auto
    footer_mode: "25"
    # the precision for displaying floats in tables
    float_precision: 1
    # command that will be used to edit the current line buffer with ctrl+o, if
    # unset fallback to $env.EDITOR and $env.VISUAL
    # buffer_editor: "emacs"
    use_ansi_coloring: true
    # enable bracketed paste, currently useless on windows
    bracketed_paste: true
    # emacs, vi
    edit_mode: vi
    # enables terminal markers and a workaround to arrow keys stop working issue
    shell_integration: true
    # true or false to enable or disable right prompt to be rendered on last
    # line of the prompt.
    render_right_prompt_on_last_line: true

    hooks: {
        pre_prompt: [{ ||
            # replace with source code to run before the prompt is
            # generated/inserted
            null
        }]
        pre_execution: [{||
            # replace with source code to run before the repl input is run
            null
        }]
        env_change: {
            # replace with source code to run if the PWD environment is
            # different since the last repl input
            PWD: [{|before, after|
                null
            }]
        }
        display_output: {||
            if (term size).columns >= 100 { table -e } else { table }
        }
        # replace with source code to return an error message when a command is
        # not found
        command_not_found: {||
            null
        }
    }
    menus: [
        # Configuration for default nushell menus
        # Note the lack of source parameter
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "󰺾 "
            type: {
                layout: columnar
                columns: 4
                # Optional value. If missing all the screen width is used to
                # calculate column width
                col_width: 20
                col_padding: 2
            }
            style: {
                text: blue
                selected_text: blue_reverse
                description_text: light_red
            }
        }
        {
            name: history_menu
            only_buffer_difference: true
            marker: "󰔟 "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: light_red
            }
        }
        {
            name: help_menu
            only_buffer_difference: true
            marker: "󰮦 "
            type: {
                layout: description
                columns: 4
                # Optional value. If missing all the screen width is used to
                # calculate column width
                col_width: 20
                col_padding: 2
                selection_rows: 4
                description_rows: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: light_blue
            }
        }
        # Example of extra menus created using a nushell source
        # Use the source field to create a list of records that populates
        # the menu
        {
            name: commands_menu
            only_buffer_difference: false
            marker: "󰛕 "
            type: {
                layout: columnar
                columns: 4
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: light_blue
            }
            source: { |buffer, position|
                $nu.scope.commands
                | where name =~ $buffer
                | each { |it| {value: $it.name description: $it.usage} }
            }
        }
        {
            name: vars_menu
            only_buffer_difference: true
            marker: "󰫧 "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: light_blue
            }
            source: { |buffer, position|
                $nu.scope.vars
                | where name =~ $buffer
                | sort-by name
                | each { |it| {value: $it.name description: $it.type} }
            }
        }
        {
            name: cd_menu
            only_buffer_difference: true
            marker: " "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: light_red
            }
            source: { |buffer, position|
                ls
                | where (type == dir) and (name ~= $buffer)
                | fzf --no-multi --cycle
                | lines
                | each { |it| {value: $it.name description: $it.name} }
            }
        }
        {
            name: commands_with_description
            only_buffer_difference: true
            marker: "󱍁 "
            type: {
                layout: description
                columns: 2
                col_width: 20
                col_padding: 4
                selection_rows: 4
                description_rows: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: light_blue
            }
            source: { |buffer, position|
                $nu.scope.commands
                | where name =~ $buffer
                | each { |it| {value: $it.name description: $it.usage} }
            }
        }
    ]
    keybindings: [
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: completion_menu }
                    { send: menunext }
                ]
            }
        }
        {
            name: default_menu_previous
            modifier: shift
            keycode: backtab
            # Note: You can add the same keybinding to all modes by using a list
            mode: [emacs, vi_normal, vi_insert]
            event: { send: menuprevious }
        }
        {
            name: menu_up
            modifier: control
            keycode: char_k
            mode: [vi_insert vi_normal]
            event: { send: menuup }
        }
        {
            name: menu_down
            modifier: control
            keycode: char_j
            mode: [vi_insert vi_normal]
            event: { send: menudown }
        }
        {
            name: menu_left
            modifier: control
            keycode: char_h
            mode: [vi_insert vi_normal]
            event: { send: menuleft }
        }
        {
            name: menu_right
            modifier: control
            keycode: char_l
            mode: [vi_insert vi_normal]
            event: { send: menuright }
        }
        {
            name: menu_next
            modifier: control
            keycode: char_n
            mode: [vi_normal vi_insert]
            event: { send: menunext }
        }
        {
            name: menu_previous
            modifier: control
            keycode: char_p
            mode: [vi_normal vi_insert]
            event: { send: menuprevious }
        }
        {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: [vi_normal vi_insert]
            event: { send: menu name: history_menu }
        }
        {
            name: next_page
            modifier: shift_control
            keycode: char_n
            mode: [vi_normal vi_insert]
            event: { send: menupagenext }
        }
        {
            name: previous_page
            modifier: shift_control
            keycode: char_p
            mode: [vi_normal vi_insert]
            event: { send: menupageprevious }
        }
        {
            name: unix-line-discard
            modifier: shift_control
            keycode: char_u
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {edit: cutfromlinestart}
                ]
            }
        }
        {
            name: kill-line
            modifier: shift_control
            keycode: char_k
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {edit: cuttolineend}
                ]
            }
        }
        # Keybindings used to trigger the user defined menus
        {
            name: commands_menu
            modifier: control
            keycode: char_t
            mode: [emacs, vi_normal, vi_insert]
            event: { send: menu name: commands_menu }
        }
        {
            name: vars_menu
            modifier: control
            keycode: char_o
            mode: [emacs, vi_normal, vi_insert]
            event: { send: menu name: vars_menu }
        }
        {
            name: commands_with_description
            modifier: control
            keycode: char_s
            mode: [emacs, vi_normal, vi_insert]
            event: { send: menu name: commands_with_description }
        }
        {
            name: cd_menu
            modifier: control
            keycode: char_z
            mode: [vi_normal vi_insert]
            event: { send: menu name: cd_menu }
        }

    ]
}

const CONFIG_DIR = (["~", ".config"] | path join)

# ─[ Section: direnv: ]─────────────────────────────────────────────────────

# as of a recentish update to nushell, it seems as though the proper hook into
# the direnv package is supposed to be set up this way instead. Note that we
# able to auto-update this when needed.
$env.DIRENV_LOG_FORMAT = ""
$env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD
    | append (
        source (
            [$nu.default-config-dir "hooks" "direnv.nu"]
            | path join)
        )
    )

# ─[ Section::Zoxide: Autojump Manager ]────────────────────────────────────

# Zoxide is a modern-age replacement for the cd command, which provides history,
# frecency, etc. as a more efficient method of changing directories on the
# command line.

# this is provided by nushell
source ([$nu.default-config-dir "external" "zoxide.nu"] | path join)

# ─[ Section::nnn ]─────────────────────────────────────────────────────────

# this sets up the cd-on-quit behavior for nnn, namely by defining the new,
# correct invocation of nnn to be simply `n`.
source ([$nu.default-config-dir "external" "nnn-quitcd.nu"] | path join)

# ─[ Section::weechat ]───────────────────────────────────────────────────

# this sets up weechat by calling the predefined script that I have which
# defines the new chat command.
export use ([$nu.default-config-dir "external" "weechat.nu"] | path join) *

# ─[ Secton::pspg ]───────────────────────────────────────────────────────

# set up pspg tabular data pager
export use ([$nu.default-config-dir "external" "pspg.nu"] | path join) *

# ─[ Section::Zellij ]────────────────────────────────────────────────────

# eventually, this section will hold the call to an external script that will
# hold the autostart logic for zellij. This does depend somewhat on whether
# Zellij will stop interrupting my keybindings

# ─[ Section::broot ]───────────────────────────────────────────────────────

# broot is a file manager, a nice view of a file-tree directly in the terminal
# with a speedy ui and reasonably simple keybindings. this is supposed to hook
# up to vim, but so far I'm not there yet.
source ([$CONFIG_DIR "broot" "launcher" "nushell" "br"] | path join)

# ─[ Section::Yazi ]────────────────────────────────────────────────────────

# yazi is another file manager, it is not too dissimilar to broot I think but
# with some different choices but also implemented using Rust for speed
source ([$CONFIG_DIR "yazi" "launcher" "nushell" "ya"] | path join)

# ─[ Section::Extension Bin ]───────────────────────────────────────────────

# this sets up some custom directories that are used to hold things like
# downloaded scripts, custom completions, externs, etc.
export use libstd *
export use core *
export use completions *
export use utils *
export use aliases *

# ─[ Section::gpg fix ]─────────────────────────────────────────────────────

# to make gpg agent work correctly
$env.GPG_TTY = (tty)

# ─[ section::starship ]──────────────────────────────────────────────────

use ~/.cache/starship/init.nu

# do --env {|| bash -c eval '$(zellij setup --generate-auto-start bash)'}
