export def main [
    ...$args: any
    --predicate: closure
] {
    let testargs = (if $predicate != null {
        $args | filter $predicate
    } else {
        $args
    })

    let found = $testargs | filter {|it| $it != null}

    $found | first
}
