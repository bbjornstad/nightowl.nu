#!/usr/bin/env nu
# vim: set ft=nu:

# raur: Paru Wrapper

export def main [] { }

export def "raur remove" [
    --nofuzz(-f)
] {
    let inp = (run-external --redirect-stdout "paru" "-Qq")
    let remove_targets = (if not $nofuzz {
        ($inp
         | ^fzf --multi --preview 'paru -Qi {1}')
    } else {
        $inp
    })
    ($remove_targets
     | ^xargs -ro paru -Rnsc)
}

export def "raur clean" [
    --skip-orphans(-o)
    --skip-cache(-c)
    --review(-r)
] {
    if not $skip_orphans {
        let orph = (run-external --redirect-stdout "paru" "-Qtdq")
        let remove_targets = (if $review {
            ($orph | ^fzf --multi --preview 'paru -Qi {1}')
        } else {
            $orph
        })
    }
    if not $skip_cache {
        run-external "paru" "-Scc"
    }
}

export def --wrapped "raur install" [
    --nofuzz(-f)
    ...args
] {
    let inp = (run-external --redirect-stdout "paru" "-Slq")
    let install_targets = (if not $nofuzz {
        ($inp
         | ^fzf --multi --preview 'paru -Si {1}')
    } else {
        $inp
    })

    ($install_targets |
     | ^xargs -ro paru -Syu ...$args)
}

export def "raur list" [
    --explicit(-e)
    --dependencies(-d)
    --outdated(-u)
    --ls-files(-f)
    --information(-i)
] {
    mut cmdargs = ["-Q"]
    $cmdargs = ($cmdargs | append (if $explicit { ["-e"] } else { [] }))
    $cmdargs = ($cmdargs | append (if $dependencies { [ "-d" ] } else { [] }))
    $cmdargs = ($cmdargs | append (if $outdated { [ "-u" ] } else { [] }))
    $cmdargs = ($cmdargs | append (if $ls_files { ["-l"] } else { [] }))
    $cmdargs = ($cmdargs | append (if $information { ["-i"] } else { [] }))
    run-external --redirect-combine "paru" ...$cmdargs
}

export def --wrapped "raur search" [
    --nofuzz(-f)
    ...args
] {
    let inp = (run-external --redirect-stdout "paru" "-Ss" ...$args)
    let search_targets = (if not $nofuzz {
        ($inp | ^fzf --multi --preview 'paru -Qi {1}')
    } else {
        $inp
    })
    ($inp
     | ^xargs -ro paru -Ss ...$args)
}

export def --wrapped "raur spec" [
    --name(-n): path
    --dry-run(-D)
    --with-dependencies(-d)
    --in-aur(-a)
    --in-repo(-r)
    --force(-f)
    ...args
] {
    let file_name = ($name | default "./archpkg.txt")
    let noforce = (not $force)
    let baseargs = ["-Q" "-q" "-e"]

    let cmdargs = (if $with_dependencies {
        ($baseargs | append ["-d"])
    } else {
        $baseargs
    })
    let repoargs = if $in_repo {
        ($cmdargs | append ["-m"])
    } else {
        $cmdargs
    }
    let aurargs = if $in_aur {
        ($cmdargs | append "-n")
    } else {
        $cmdargs
    }
    let repos = ((^paru ...$repoargs) | lines)
    let aurs = ((^paru ...$aurargs) | lines)

    let req = { repository: $repos, aur: $aurs }

    if not $dry_run {
        if ($name | path exists) {
            print (["File already exists:\n" $name])
            if not $noforce {
                return 1
            }
        }
        ($req
         | to text
         | save -f $file_name)
    } else {
        $req
    }
}
