{ ||
    let res = (^vivid generate "jellybeans")
    $env.LS_COLORS = $res
    $res
}
