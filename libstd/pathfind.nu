export def path-home [] {
    $env.HOME
}

export def join-home [...args] {
    (path-home) | path join
}

export def "join home" [...args] {
    [(path-home) ...$args] | path join
}

export def "join config" [...args] {
    join home ".config"
}

export def "join prj" [...args] {
    join home "prj"
}

export def "join org" [...args: path] {
    join home "org"
}

export def "join bin" [...args: path] {
    join home "bin"
}
