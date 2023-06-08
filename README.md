# nightshell:

`nightshell` is a simple configuration for the [nushell.sh](https://nushell.sh)
command line shell. Nushell is a modern shell, written in Rust (which brings
some challenges occasionally, but mainly exceedingly nice safety and error
output messages).

Unfortunately, it is different enough from typical shell configuration, and so I
am in the process of essentially recreating all of my environment variables,
aliases, or command definitions in an appropriate, nu-idiomatic (to the extent
that such a thing exists) way.

## Installation

The typical method of using this configuration is to include it in a larger
dotfiles management setup as a git submodule, pointed at your
`$XDG_CONFIG_HOME/nushell` or `$HOME/.config/nushell` directory. There's no
reason you couldn't clone this to any old spot and use the scripts from there
(perhaps by including them in an already existing configuration's `env.nu` or
`config.nu` file)
