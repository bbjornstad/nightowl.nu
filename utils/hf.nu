#!/usr/bin/env nu
# vim: set ft=nu:

# `hf` is a utility for interacting with huggingface via the command line. As a
# result, the `huggingface-hub` package must be installed for this module to do
# anything.

export module completes-hf-externs {
    export def repo-type [] {
        ['model', 'dataset', 'space']
    }
}

use completes-hf-externs

export module hf-externs {
    export extern 'huggingface-cli' [
        --help (-h) # show help text
    ]

    # prints information about the environment which is executing the subcommand
    export extern 'huggingface-cli env' [
        --help (-h) # show help text for `env` subcommand
    ]

    # log in using a token from https://huggingface/settings/tokens
    export extern 'huggingface-cli login' [
        --token: string # token generated from https://huggingface.co/settings/tokens
        --add-to-git-credential # save token to git credential helper
        --help (-h) # show help text for `login` subcommand
    ]

    # find out which huggingface.co account you are currently using
    export extern 'huggingface-cli whoami' [
        --help (-h) # show help text for `whoami` subcommand
    ]

#   # log out
    export extern 'huggingface-cli logout' [
        --help (-h) # show help text for `logout` subcommand
    ]

    # { create } commands to interact with your huggingface.co repositories
    export extern 'huggingface-cli repo' [
        --help (-h) # show help text for `repo` subcommand
    ]

    # upload a file or a folder to a repo on the huggingface hub
    export extern 'huggingface-cli upload' [
        repo_id: string # identifier of the repo containing the target model, e.g. `username/repo-name`
        local_path?: path='.' # local path of file or folder to upload; defaults to current directory
        path_in_repo?: path # path of the file or folder in the repository; defaults to relative path as represented locally
        --help (-h) # show help text for `huggingface-cli upload`
        --repo-type: string@'completes-hf-externs repo-type' # the type of the repo that is to be uploaded
        --revision: string # an optional git revision to push to. Can be a branch name or a PR reference. If revision does not exist and `--crreate-pr` is not set, a branch will be automatically created
        --private # whether the repo should be made private if it doesn't exist on the hub prior to this upload
        --include: glob # glob patterns to match files to upload
        --exclude: glob # glob patterns to match files not skip during upload
        --delete: glob # glob patterns to match files to delete from the repo while committing
        --commit-message: string # the summary/title/first line of the generated commit
        --commit-description: string # the description of the generated commit
        --create-pr # whether to upload content as a new pull request
        --every: int # if set, a background job is scheduled creating commits repeatedly after the number of minutes given as the value have passed.
        --token: string # user access token generated from https://huggingface.co/settings/tokens
        --quiet # progress bars are disabled and only the path to uploaded files is printed
    ]

    # download files from the huggingface-hub
    export extern 'huggingface-cli download' [
        repo_id: string # identifier of the repo containing the target model to download from
        ...filenames: path # files to download, e.g. `config.json`, `data/metadata.jsonl`, etc
        --help (-h) # show help for `huggingface-cli download`
        --repo-type: string@'completes-hf-externs repo-type' # the type of the repo that is to be downloaded
        --revision: string # an optional git revision id which can be a branch name, tag, or commit hash
        --include: glob # glob patterns to match files to download
        --exclude: glob # glob patterns to match files to exclude from download
        --cache-dir: path # path to directory where downloaded files can be cached
        --local-dir: path # if set, the model is placed in this directory.
        --local-dir-use-symlinks # deprecated and ignored; downloading file to local path no longer uses symlinks
        --force-download # if true, files are redownloaded even if there is matching local content in the cache
        --resume-download # deprecated and ignored; downloading file to local path always attempts resumption of interrupted downloads
        --token: string # user access token generated from https://huggingface.co/settings/tokens
        --quiet # if true, progress bars are disabled and only the path to the downloaded files is printed
    ]

    # configures the repository to enable file uploads > 5gb
    export extern 'huggingface-cli lfs-enable-largefiles' [
        path: path # local repository path to configure
        --help (-h) # show help for 'huggingface-cli lfs-enable-largefiles'
    ]

    # scans the cache directory
    export extern 'huggingface-cli scan-cache' [
        --help(-h) # show help for `huggingface-cli scan-cache`
        --dir: directory # cache directory to scan
        --verbose (-v) # use verbose message output
    ]

    # deltes items in the cache
    export extern 'huggingface-cli delete-cache' [
        --help (-h) # show help for `huggingface-cli delete-cache`
        --dir: directory # cache directory to clear
        --disable-tui # disable TUI mode, useful if terminal doesn't support multiselect
    ]


    # create, list, and delete tags for repositories in the hub
    export extern 'huggingface-cli tag' [
        repo_id: string # identifier of the repo containing the target model, e.g. `username/repo-name`
        tag: string # the tag that should be applied
        --help (-h) # show help for `huggingface-cli tag`
        --message (-m) # description content for the tag
        --revision: string # a git revision which should receive the tag
        --token: string # an access token generated from https://huggingface.co/settings/tokens
        --repo-type: string@'completes-hf-externs repo-type' # sets the type of repository
        --yes (-y) # answer Yes automatically whenever prompted
        --list (-l) # list tags for a given repository
        --delete (-d) # delete tags for a given repository
    ]
}

export use hf-externs *
