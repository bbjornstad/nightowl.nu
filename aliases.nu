#!/usr/bin/env nu
# vim: set ft=nu:

# ------------------------------------------------------------------------------
# vim aliases: make sure that we are using the correct pager in nvimpager and
# our vim call directly gets back to nvim
export alias vim = nvim
# export alias less = nvimpager

# ------------------------------------------------------------------------------
# aliases for file managers.
export alias nnn = with-env { MANPAGER: bat } { nnn }

# ------------------------------------------------------------------------------
# hyprland specific aliases:
# - restart waybar with a SIGUSR2 signal.
export alias wayedit = killall -SIGUSR2 waybar

# ------------------------------------------------------------------------------
# configuration file edit aliases:
# these are shortcuts to open an editor (nvim) on the specified configuration
# file.
# export alias shellconf = ([$env.HOME, .profile] | path join | nvim)
# export alias shelldconf = ([$env.HOME, .profile.d] | path join | nvim)
# export alias vimconf = ([$env.HOME, .config, nvim] | path join | nvim)
# export alias termconf = ([$env.HOME .config wezterm wezterm.lua] | path join | nvim)


# # ------------------------------------------------------------------------------
# # help formatting: currently broken?
# # - Should set up bat the correct way to display the help file for the given
# #   command.
# export def help [command: string] {
#   $command out+err> | bat --plain --language=help
# }

# ------------------------------------------------------------------------------
# ls based rebindings: get more information for less keystrokes.
# - Simply defines a few aliases that I use to query directories in a more
#   specific fashion.
export alias lsd = ls --long
export alias lsa = ls --long
export alias ald = ls --long --all
export alias aldt = ls --long --all
export alias ls = ls --long

# ------------------------------------------------------------------------------
# emotive package management:
# The following configuration snafu has arisen: I want to use paru to manage
# packages as it seems more powerful than yay, but the way that yay and yeet
# work as aliases for these commannds is too good to not keep. Yeet that shit
# off the nearest bridge why don't you?
export alias yay = paru -Syu
export alias yeet = paru -Rns
export alias eet = sudo pacman -Rns

# ------------------------------------------------------------------------------
# changing the binding of the man command to point directly to batman instead of
# man. This is to facilitate colorizing the man commands output.
# export alias man = nvim

# ------------------------------------------------------------------------------
# correctly set up the replacements for the following commands, to more sensible
# default implementations that we get in 2023
# - cat -> bat
# - grep -> rg
# - find -> fd
# - cd -> z
export alias cat = bat
export alias grep = rg
export alias find = fd

export alias cd = __zoxide_z

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
