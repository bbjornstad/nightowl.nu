module completes {

}

use completes

module argspread {
    export def main [] {}

    export def record [
        rec: record
        --treatments: list<closure>
        --treated-args-collector: closure
    ]: nothing -> list<string> {
        let rec = $in

        let treat_args = (if (($treatments != null) and not ($treatments | is-empty)) {
            $treatments
            | each {|t| do $t $rec}
            | reduce {|it, acc| do $treated_args_collector $it $acc }
        } else {
            $rec
        })
        let arg_unpacked = $treat_args
        | items {|key, val|
            [$"--($key)" $val]
            | str join "="
        }
        ...$arg_unpacked
    }
}

export use argspread
