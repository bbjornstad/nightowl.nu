# ==============================================================================
# `ybky`: Yubikey Management Command Definitions................................
# ----------------------------------------------
# these commands define some convenience manipulations for security key usage on
# my system. In particular, we follow the excellent guide about using Yubikeys
# with PGP from Dr. Duh, which is found at the following link:
# https://github.com/drduh/YubiKey-Guide
#
# In particular, this guide stipulates that we use custom locations for the root
# of the user GNUPG directory, e.g. $GNUPGHOME (or $env.GNUPGHOME in the case of
# nushell). We define a helper that handles this translation for us, along with
# a series of other convenience wrappers for generation commands.

# `ybky`: the top-level entry point for the subcommands of ybky. Not sure that
# this will have any functionality at the end of this, perhaps just a simple
# status output would suffice.
export def --env ybky [ ] {

}

# `ybky gen`: the top-level entry point for the subcommands of `ybky gen`, which
# is for generating security token credential items in various formats that are
# supported by Yubikey: PGP, FIDO (mainly for SSH), and PIV. Also, we include an
# `age` implementation, which does require an additional dependency in the form
# of the yubico-age-plugin.
export def --env "ybky gen" [ ] {

}

# `ybky gen pgp`: generates a PGP token credential item for use on a Yubikey
# security token. These PGP tokens can be used to authenticate in some places,
# signing commits/messages/communications, and generally as a form of identity
# verification across machines and services.
export def --env "ybky gen pgp" [
    --type?: string="EC" # the type of pgp token that should be created, either EC or RSA for elliptic curve or RSA
    --size?: int=4096 # the size of the pgp token that should be created, only applicable in the case where $type == "RSA"
] {

}

# `ybky gen ssh`: generates an SSH token credential item in the form of a FIDO2
# compatible key. This is enabled with recent-enough versions of OpenSSL, and is
# the easier way to create security backed ed25519 tokens. This includes
# convenience functionality to intake relevant parameters from the environment
# or user in formatting key metadata.
export def --env "ybky gen ssh" [ ] {

}

# `ybky gen fido`: generates directly a FIDO2 token using the security key
# backing provided by recent enough versions of OpenSSL. This is a direct
# wrapper around the system calls to ssh...gen...
# TODO: determine the degree to which this is superfluous.
export def --env "ybky gen fido" [ ] {

}

# `ybky mktemp`: helper function that creates a temporary home directory for the
# duration of this session. If the --dry flag is specified, then the directory
export def --env "ybky mktemp" [
    --name: string=$"gnupg_(^date +%Y%m%d%H%M)_XXX" # the string to use as template for name of the directory; can use certain forms of syntactiw sugar, see `man mktemp`
    --dry: bool=false # whether or not the directory should be actually created; if true, will only return the path pointing to the theoretical location (unsafe).
] {
    $env.GNUPGHOME =  (mktemp --directory -t $name)
}
