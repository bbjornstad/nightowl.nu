# vim: set ft=nu ts=2 sts=2 sw=2 et:
#!/usr/bin/env nu

# ------------------------------------------------------------------------------
# set up the correct specification for the candy alias used presently. Our main
# issue in this case was the fact that nushell's environment is scoped, so we
# needed to add this as a module, but we just simply want to source the rest of
# the aliases.
# -----
export alias candy = git --git-dir $env.DOTCANDYD_USER_HOME --work-tree $env.HOME

# -----------------------------------------------------------------------------
# set up an alias that can unlock our bw cli tool as needed. This authentication
# token is very dangerous if exposed...keep it safe in .envrc.secrets, but by
# being an alias, the evaluation is deferred until the value is strictly
# necessary, and not when this file gets compiled (which is before the envrc
# hooks)
# -----
export alias bw-unlock = bw unlock --raw --passwordenv "RSP_URSA_MAJOR_AUTHKEY"
