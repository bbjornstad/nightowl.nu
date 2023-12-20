#!/usr/bin/env nu
# vim: set ft=nu:

# ------------------------------------------------------------------------------
# use of vim on the command line will actually invoke nvim instead.

export def dnvim [ ...files ] {
  with-env { NIGHTOWL_BACKGROUND_STYLE: "dark" } {
    /usr/bin/nvim $files
  }
}
export def lnvim [ ...files ] {
  with-env { NIGHTOWL_BACKGROUND_STYLE: "light" } {
    /usr/bin/nvim $files
  }
}

export alias nvim = dnvim
export alias vim = nvim

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


# ------------------------------------------------------------------------------
# help formatting: currently broken?
# - Should set up bat the correct way to display the help file for the given
#   command.
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
export alias lsl = ls --long

# ------------------------------------------------------------------------------
# emotive package management:
# The following configuration snafu has arisen: I want to use paru to manage
# packages as it seems more powerful than yay, but the way that yay and yeet
# work as aliases for these commannds is too good to not keep.
export alias yay = paru -Syu
export alias yeet = paru -Rnsc
export alias eet = sudo pacman -Rnsc

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

# ------------------------------------------------------------------------------
# add the ability to switch manpagers with an easy alias.
export def sman [
  ...pages
] {
  with-env {MANPAGER: "bat -l Manpage"} {
    man $pages
  }
}
