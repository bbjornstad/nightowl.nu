{ ||
    let overlays = overlay list | range 1..
    if not ($overlays | is-empty) {
        $env.NU_OVERLAYS = ($overlays | str join ', ')
    } else {
        $env.NU_OVERLAYS = null
    }
}
