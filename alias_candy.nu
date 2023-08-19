#!/usr/bin/env nu
# vim: set ft=nu ts=2 sw=2 sts=2 expandtab:

# ------------------------------------------------------------------------------
# set up the correct specification for the candy alias used presently. Our main
# issue in this case was the fact that nushell's environment is scoped, so we
# needed to add this as a module, but we just simply want to source the rest of
# the aliases.
# -----
export alias candy = git --git-dir $env.DOTCANDYD_USER_HOME --work-tree $env.HOME
export alias wonka = gitui --directory $env.DOTCANDYD_USER_HOME --workdir $env.HOME

export def-env nucandy [
  --git-dir (-g): path,               # path to directory holding dotcandyd bare repository
  --work-tree (-w): path,             # path to directory at root of files that should be tracked
  subcommand: string,                   # subcommand of git that should be run on this invocation of the candy cli tool
  ...pathspec: path,                   # additional pathspec items that get passed as the operands of git
] {
  mut dircandy = $env.DOTCANDYD_USER_HOME
  if ($git_dir != null) {
    $dircandy = $git_dir
  }
  mut worktree = $env.HOME
  if ($work_tree != null) {
    $worktree = $work_tree
  }
  mut full_paths = ($pathspec | str join " ")
  if ($full_paths in ["" " " null]) {
    $full_paths = "."
  }

  ^git --git-dir $dircandy --work-tree $worktree $subcommand (
    $pathspec | str join " ")
}

export def-env nuwonka [
  --git-dir (-g): path,           # path to directory holding dotcandyd repositoryy
  --work-tree (-w): path,         # path to directory at root of files that should be tracked
  ...additional_options
] {
  mut dircandy = $env.DOTCANDYD_USER_HOME
  if ($git_dir != null) {
    $dircandy = $git_dir
  }
  mut worktree = $env.HOME
  if ($work_tree != null) {
    $work_tree = $worktree
  }
  ^gitui --directory $dircandy --workdir $worktree
}
