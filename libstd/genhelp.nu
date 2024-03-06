#!/usr/bin/env nu
# vim: set ft=nu:

module genhelp {
    # operations on command help text for nushell completion and dynamic
    # descriptions; use one of the subcommands to generate output from help text
    export def "hp" [] {}

    # parse help text into nushell-usable tables; use one of the subcommands to
    # parse using a particular method
    export def "hp parse" [] {}

    # use help text to generate certain kinds of nushell-specific command
    # sweeteners; use one of the subcommands to parse help text and generate the
    # appropriate sugary goods.
    export def "hp to" [] {}

    # generate an appropriate completion for a target command directly from the
    # help text; the output is designed to be saved to a particular folder which
    # is interpretable by nushell, e.g. a custom completions folder.
    export def "hp to completion" [] {}

    # generate appropriate descriptions for a target extern; the output is
    # designed to be added as descriptive fields alongside an extern export.
    export def "hp to extern" [] {}

    # given a section defining header string, splits help text into each section
    # of the command parameters, e.g. USAGE, SUBCOMMANDS, OPTIONS, etc. The
    # default header assumes that text is self contained on a single line and
    # ends with a colon followed by a new line, and that the section's text
    # entries are indented.
    export def section-split [
        --section (-s): string='(?:^\S+):\n*?' # regex string to match help text section headings
    ] {
        let ht = $in
        let sectioned = ($ht | lines | split list --regex $section)
        $sectioned
    }

    # compute the index of the last leading space for each line of each section
    # and determine the maximal index over each section's lines; this is to say
    # that for each section, this command will find the max number of leading
    # spaces that occur preceding item descriptions in that section. This is
    # useful to prevent illegitmate matches that can occur if an item's
    # description is broken over multiple lines (due to the rather strict nature
    # of regex parsing)
    export def sectioned-max-spaces [] {
        let sect = $in
        ($sect
         | each { |it| ($it
                 # | lines
                 | inspect
                 | each { |itt| ($itt
                         | str index-of "  " --end) }
                 | math max) })
    }

    # parse help text into nushell-usable table by matching with regex; special
    # behavior: for each section, the maximal number of leading spaces is
    # counted (or rather, the index of the last leading space is computed with
    # the `str index-of` command), such that any description field which
    # contains a line break can adequately be filtered from being parsed into an
    # improper field. Note that the defaults are likely not to be trifled with,
    # but in the event that they are, flags are exposed.
    export def "hp parse regex" [
        --section (-s): string='(?:^\S+):\n*?' # regex pattern to match a help text section heading
        --item (-i): string='(?:\b(?<item>\S+)\b)' # regex pattern to match a command or subcommand item
        --flag (-f): string='(?:--(?<flag>\S+)[,\s]*?\s+?)' # regex pattern to match a command line flag option in long form, e.g. `--option`
        --shortflag (-F): string='(?:\s+-(?<shortflag>\S)[,\s]*?\s*?)' # regex pattern to match a command line flag option in short form `-o)
        --opt-argument (-a): string='(?:(?<arg>[<\[]\S+[>\]]))' # regex pattern to match an optional argument, e.g. `--option <argument>`
        --description (-d): string='(?:(?<description>(?(?<={{ PRECEDING_TOKENS }})[[.+\s]-]+\n*?)))?' # regex pattern to match the description field for an entry in help text
        --entry-padding (-e): string='((?:^\s{2, {{ MAX_ALLOWED_SPACE }}})' # regex pattern to match any padding that is placed before each item in a section
        --allow-empty (-E) # allow for empty regex matches if desired
        --preceding-tokens (-p): list<string>=['item' 'flag' 'shortflag']
    ] {
        # start setting up the various components in the correct ordering
        # necessary for proper parsing.
        let ht = $in
        let regx = ([$item $flag $shortflag $opt_argument]
                | str join '|')
        let preceders = ($preceding_tokens | each { |st| $'\g{($st)}' })
        let desc = ($description
                | str replace '{{ PRECEDING_TOKENS }}' ($preceders | str join '|'))
        print $desc
        let regexp = ([$regx $description]
                | str join '\s*')
        let sectioned = ($ht | section-split --section $section)
        let max_space = ($sectioned | sectioned-max-spaces)

        ($sectioned
         | enumerate
         | inspect
         | each { |it| ($it.item
                 | each { |itt| $itt | parse --regex ($regexp
                         | str replace '{{ MAX_ALLOWED_SPACE }}' ($max_space
                             | get $it.index)) }) }
         | reduce { |it,acc| ($it | append $acc) })
    }

    export def "hp parse carapace" [
    ] {
        let compl = { |spans, buffer| carapace $spans.0 }
    }
}

export use genhelp *
