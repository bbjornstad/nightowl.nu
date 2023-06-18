#!/usr/bin/env nu

# ------------------------------------------------------------------------------
# set up the correct specification for the candy alias used presently. Our main
# issue in this case was the fact that nushell's environment is scoped, so we
# needed to add this as a module, but we just simply want to source the rest of
# the aliases.
# -----
export alias candy = git --git-dir $env.DOTCANDYD_USER_HOME --work-tree $env.HOME
