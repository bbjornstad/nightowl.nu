export def home-path [] {
    $env.HOME
}

export def "join home" [...args] {
    [(home-path) ...$args | path join]
}

export def "join config" [...args] {
    join home ".config"
}
