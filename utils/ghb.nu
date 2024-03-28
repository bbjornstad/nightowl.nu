#!/usr/bin/env nu
# vim: set ft=nu:

#SPDX-FileCopyrightText: 2024 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
#SPDX-License-Identifier: MIT

#MIT License

# Copyright (c) 2024 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

#Permission is hereby granted, free of charge, to any person obtaining a copy of
#this software and associated documentation files (the "Software"), to deal in
#the Software without restriction, including without limitation the rights to
#use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
#of the Software, and to permit persons to whom the Software is furnished to do
#so, subject to the following conditions:

#The above copyright notice and this permission notice (including the next
#paragraph) shall be included in all copies or substantial portions of the
#Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

# helper module container for github binary downloads
module ghb {
    # top-level github binary release download url format command; must use one
    # of the subcommands `fmt api` or `fmt direct`
    def "fmt" [] {}

    # parses and formats a url pointing to the target github repository's
    # release assets in the github API
    def "fmt api" [
        repo: string # repository identifier in `username/reponame` format
        --release: string='latest' # identifier for the target release version
    ] {
        let url = ({
                "scheme": "http",
                "username": "",
                "password": "",
                "host": "api.github.com",
                "port": "",
                "path": (["repos" $repo "releases" $release] | str join "/")
                } | url join)
        (echo $url)
        $url
    }

    # parses and formats a url pointing to the target github repository's
    # release assets directly through github without the API
    def "fmt direct" [
        repo: string # repository identifier in `username/reponame` format
        --filename: string # target release asset filename
        --release: string="latest" # identifier for the target release version
    ] {
        let url = ({
            "scheme": "http",
            "username": "",
            "password": "",
            "host": "github.com",
            "port": "",
            "path": ([$repo "releases" $release "download" $filename]
                    | str join "/")
        } | url join)
    }

    # given release asset and repository parameters, fetches release assets
    # from the github API, returning a table with columns "name" "id" and
    # "content" with each matching asset name, github API ID, and binary
    # content.
    export def "fetch api" [
        repo: string # repository identifier in `username/reponame` format
        --auth: string # as-needed authentication token for protected repositories
        --release: string='latest' # identifier for the target release version
        --filename: string # target asset filenames to match using regex
    ] {
        let auth_header = (if $auth != null {
            ["Authorization" ([" Bearer" $auth] | str join " ")]
        } else { [] })
        let stream_header = ["Accept" "application/octet-stream"]
        let full_headers = ($stream_header | prepend $auth_header)
        let url = (fmt api --release $release $repo)
        let getres = (http get
                --redirect-mode follow
                --headers $auth_header
                $url)
        let assets_url = ($getres.assets_url | inspect)
        let assets = (
                (http get
                 --redirect-mode follow
                 --headers $auth_header
                 $assets_url)
                | where name =~ $filename)
        let bin = (($assets
                    | insert content { |row| (
                            http get
                            --redirect-mode follow
                            --headers $full_headers
                            $row.url) })
                | select ...["name" "id" "content"])
        $bin
    }

    # given release asset and repository parameters, fetches the target release
    # asset without using github API, e.g. using the "standard" link that one
    # would use in a browser
    export def "fetch direct" [
        repo: string # repository identifier in `username/reponame` format
        --release: string='latest' # identifier for the target release version
        --filename: string # target release asset filename
    ] {
        let url = (fmt direct $repo --release $release --filename $filename)
        let bin = (http get --redirect-mode follow $url)
        $bin
    }
}

export use ghb

# download a binary release of a software repository from github by
# specification of a repository in `username/reponame` format
export def main [
    repo: string # repository identifier in `username/reponame` format
    --release (-r): string='latest' # identifier for the target release version
    --auth (-a): string # as-needed authentication token for protected repositories
    --filename (-f): string # target release asset filename to match with regex
    --output (-o): directory # target directory on local machine where the file should be downloaded
] {
    let out = (if $output != null {
        $output
    } else {
        $env.HOME
    })
    ((ghb fetch api
      --release $release
      --auth $auth
      --filename $filename
      $repo)
     | each { |it| $it.content | save ([$out $it.name] | path join)})
}

# download a binary release of a software repository from github by
# specification of a repository in `username/reponame` format, bypassing github
# API calls by directly using browser link
export def "ghb direct" [
    repo: string # repository identifier in `username/reponame` format
    --release (-r): string='latest' # identifier for the target release version
    --filename (-f): string # target release asset filename
    --output (-o): directory # target directory on local machine where the file should be downloaded
] {
    let out = (if $output != null {
        $output
    } else {
        $env.HOME
    })
    ((ghb fetch direct
      --release $release
      --filename $filename
      $repo)
     | save ([$out $filename] | path join))
}
