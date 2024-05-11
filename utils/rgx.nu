# holds regex for helptext

let punct_delimited_words = '(?>\\w+[[:punct:]]?)+'
let whitespace_delimited_words = '(?>\\w+[[:blank:]]?)+'
let section = $'^\(?<section>($whitespace_delimited_words)\)'
let subsection = $'^[[:blank:]]{1}\(?<subsection>($whitespace_delimited_words)\)'

module regex_parser {

}

use regex_parser *

module help_regex {
    export def words [
        --delimit: string
    ]: nothing -> string {
        $'\(?>\w+($delimit)\)+'
    }

    export def heading [
        pattern?: string
        --name: string
        --indentation: int=0
        --prefix-char: string=' '
    ]: string -> string  {
        let input = ($in or $pattern) | default $in
        mut prefix = ['^']
        for i in 1..$indentation {
            $prefix = $prefix | append $prefix_char
        }
        let str_prefix = $prefix | str join ''
        $'($str_prefix)\(?<($name)>($input)\)'
    }

    export def section [
        pattern?: string
        --indentation: int=0
        --prefix-char: string=' '
    ]: string -> string {
        let input = ($in or $pattern) | default $in
        (heading
         --indentation=$indentation
         --prefix-char=$prefix_char
         --name='section'
         $input)
    }

    export def subsection [
        pattern?: string
        --indentation: int=1
        --prefix-char: string=' '
    ]: string -> string {
        let input = ($in or $pattern) | default $in
        (heading
         --indentation=$indentation
         --prefix-char=$prefix_char
         --name='subsection'
         $input)
    }

    export def item [
        components: list<string>
        --name: string
        --indentation: int=2
        --prefix-char: string=' '
    ]: list<string> -> string {
        let input = ($in or $components) | default $in
        mut prefix = ['^']
        for i in 1..$indentation {
            $prefix = $prefix | append $prefix_char
        }
        let final_prefix = $prefix | str join ''
        let pattern = $input | str join ''
        if $description {
            $'($final_prefix)\(?<($name)>($pattern)\)'
        }
        $'($prefix)\(?<($name)>($pattern)\)'
    }

    export def description [
       --preceding-item:  string
       --allow-newline
    ] {}

    export def subcommand [
        pattern?: string
        --indentation: int=2
        --prefix-char: string=' '
    ] {
        let input = ($in or $pattern) | default $in

    }

    export def option [
        --type: string=''
    ] {
    }

    export def escape [
    ] {
    }

    export def "escape jq" [
        pattern: string
    ] {
        $pattern | str replace --no-expand --all --regex '\(?:[^()])' '\\'
    }
}

module man_regex {

}

export use help_regex *
export use man_regex *
