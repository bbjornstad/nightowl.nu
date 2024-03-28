# nightowl.nu

`nightowl.nu` is a simple configuration for the [nushell.sh](https://nushell.sh)
command line shell. Nushell is a modern shell, written in Rust (which brings
some challenges occasionally, but mainly exceedingly nice safety and error
output messages).

Please note that nushell is bleeding-edge software, and occasionally breaking
changes are introduced to the original e package that may prevent some scripts
or tools used in this repository from working correctly. The best place to find
such information is on [nushell's GitHub
page](https://github.com/nushell/nushell).

## Installation

The typical method of using this configuration is to include it in a larger
dotfiles management setup as a git subcomponent (submodule or subtree), pointed
at your `$XDG_CONFIG_HOME/nushell` or `$HOME/.config/nushell` directory. There's
no reason you couldn't clone this to any old spot and use the scripts from there
(perhaps by including them in an already existing configuration's `env.nu` or
`config.nu` file).
