# vim: set ft=nu:
#!/usr/bin/env nu

# ------------------------------------------------------------------------------
# Temporary Candy Setup
# -----
# this is technically going to be moved into a submodule.
# doing so requires that I get the dotcandyd package to a usable initial state,
# somewhat more challenging than anticipated.
$env.DOTCANDYD_USER_HOME
def-env candy [...args] {
  (/usr/bin/env git
   --git-dir $env.DOTCANDYD_USER_HOME
   --work-tree $env.HOME
   $args)
}

# ------------------------------------------------------------------------------
# vim aliases: make sure that we are using the correct pager in nvimpager and
# our vim call directly gets back to nvim
alias vim = nvim
# alias less = nvimpager

# ------------------------------------------------------------------------------
# hyprland specific aliases:
# - restart waybar with a SIGUSR2 signal.
alias wayedit = killall -SIGUSR2 waybar

# ------------------------------------------------------------------------------
# configuration file edit aliases:
# these are shortcuts to open an editor (nvim) on the specified configuration
# file.
# alias shellconf = ([$env.HOME, .profile] | path join | nvim)
# alias shelldconf = ([$env.HOME, .profile.d] | path join | nvim)
# alias vimconf = ([$env.HOME, .config, nvim] | path join | nvim)
# alias termconf = ([$env.HOME .config wezterm wezterm.lua] | path join | nvim)


# ------------------------------------------------------------------------------
# help formatting: currently broken?
# - Should set up bat the correct way to display the help file for the given
#   command.
def help [command: string] {
  $command out+err> | bat --plain --language=help
}

# ------------------------------------------------------------------------------
# ls based rebindings: get more information for less keystrokes.
# - Simply defines a few aliases that I use to query directories in a more
#   specific fashion.
alias lsd = ls --long
alias lsa = ls --long
alias ald = ls --long --all
alias aldt = ls --long --all
alias ls = ls --long

# ------------------------------------------------------------------------------
# emotive package management:
# The following configuration snafu has arisen: I want to use paru to manage
# packages as it seems more powerful than yay, but the way that yay and yeet
# work as aliases for these commannds is too good to not keep. Yeet that shit
# off the nearest bridge why don't you?
alias yay = paru -Syu
alias yeet = paru -Rns
alias eet = sudo pacman -Rns

# ------------------------------------------------------------------------------
# changing the binding of the man command to point directly to batman instead of
# man. This is to facilitate colorizing the man commands output.
alias man = batman

# ------------------------------------------------------------------------------
# correctly set up the replacements for the following commands, to more sensible
# default implementations that we get in 2023
# - cat -> bat
# - grep -> rg
# - find -> fd
# - cd -> z
#def-env cat [...args] {
#  if not (which bat | is-empty) {
#    $args | str join " " | bat
#  } else {
#    $args | str join " " | open --raw
#  }
#}
#def-env grep [...args] {
#  if not (which rg | is-empty) {
#    $args | str join " " | rg
#  } else {
#    $args | str join " " | grep
#  }
#}
#def-env find [...args] {
#  if not (which fd | is-empty) {
#    $args | str join " " | fd
#  } else {
#    $args | str join " " | find
#  }
#}
#def-env cd [...args] {
#  if not (which zoxide | is-empty) {
#    $args | str join " " | __zoxide_z
#  } else {
#    $args | str join " " | cd
#  }
#}
