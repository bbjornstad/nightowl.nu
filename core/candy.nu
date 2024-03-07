#!/usr/bin/env nu
# vim: set ft=nu:

# ------------------------------------------------------------------------------
# set up the correct specification for the candy alias used presently. Our main
# issue in this case was the fact that nushell's environment is scoped, so we
# needed to add this as a module, but we just simply want to source the rest of
# the aliases.
# -----
def "nu-complete candy" [context: string] {
    ^git help -a | complete | get stdout | lines | parse --regex '\s{2,}(?<cmd>\S+)\s{2,}(?<desc>.+)' | each {|it| { value: $it.cmd description: $it.desc } }
}

export def --env --wrapped main [
    --git-dir (-g): path                         # path to directory holding dotcandyd bare repository
    --work-tree (-w): path                       # path to directory at root of files that should be tracked
    subcommand: string@"nu-complete candy"       # subcommand of git that should be run on this invocation of the candy cli tool
    ...args: string                              # additional possible git arguments
] {
    let dircandy = $git_dir | default $env.DOTCANDYD_USER_HOME
    let worktree = $work_tree | default $env.HOME

    ^git --git-dir $dircandy --work-tree $worktree $subcommand ...$args
}

export extern gitui [
    --theme (-t): path
    --logging (-l)
    --watcher
    --bugreport
    --directory (-d): directory
    --workdir (-w): directory
    --help (-h)
    --version (-V)
]

export def --env --wrapped wonka [
  --git-dir (-g): path,           # path to directory holding dotcandyd repository
  --work-tree (-w): path,         # path to directory at root of files that should be tracked
  ...args: string                 # additional possible gitui arguments
] {
  let dircandy = $git_dir | default $env.DOTCANDYD_USER_HOME
  let worktree = $work_tree | default $env.HOME
  ^gitui --directory $dircandy --workdir $work_tree ...$args
}
