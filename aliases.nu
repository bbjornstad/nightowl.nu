# vim: set ft=nu:
#!/unullsr/bin/env nu

# ------------------------------------------------------------------------------
# Temporary Candy Setup
# -----
# this is technically going to be moved into a submodule
alias candy = /usr/bin/env git --git-dir=~/.candy.d --work-tree=$env.HOME

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
alias shellconf = nvim $env.HOME/.profile
alias shelldconf = nvim $env.HOME/.profile.d
alias vimconf = nvim $env.HOME/.config/nvim
alias termconf = nvim $env.HOME/.config/wezterm/wezterm.lua

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
# correctly set up zoxide for nushell by aliasing the cd command to be the z
# macro like it normally is set in my zsh configuration
def-env cat [...args] {
  if (which bat) {
    bat $args
  } else {
    open --raw $args
  }
}
