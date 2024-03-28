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

def 'nu-complete valgrind-tool' [] {
    [
        "memcheck"
        "cachegrind"
        "callgrind"
        "helgrind"
        "drd"
        "massif"
        "dhat"
        "lackey"
        "none"
        "exp-bbv"
    ]
}

def 'nu-complete valgrind-yesno' [] {
    ["yes" "no"]
}

def 'nu-complete valgrind-yesnofull' [] {
    ["yes" "no" "full"]
}

def 'nu-complete valgrind-vgdbstopat' [] {
    ["startup" "exit" "abexit" "valgrindabexit" "all" "none"]
}

export extern valgrind [
    --tool: string@'nu-complete valgrind-tool'="memcheck"
    --help (-h)
    --help-debug
    --help-dyn-options
    --version
    --quiet (-q)
    --verbose (-v)
    --trace-children: string@'nu-complete valgrind-yesno'="no"
    --trace-children-skip: string
    --trace-children-skip-by-arg: string
    --child-silent-after-fork=string@'nu-complete valgrind-yesno'="no"
    --vgdb: string@'nu-complete valgrind-yesnofull'="no"
    --vgdb-error: int=999999999
    --vgdb-stop-at: string@'nu-complete valgrind-vgdbstopat'="none"
    --track-fds: string@'nu-complete valgrind-yesnofull'="no"
    --time-stamp: string@'nu-complete valgrind-yesno'="no"
    --log-fd: int=2
    --log-file: path
    --log-socket: string
    --enable-debuginfod: string@'nu-complete valgrind-yesno'
    --xml: string@'nu-complete valgrind-yesno'
    --xml-fd: int=-1
    --xml-file: path
    --xml-socket: string
    --xml-user-comment: string
    --demangle: string@'nu-complete valgrind-yesno'
    --num-callers: int=12
    --unw-stack-scan-thresh: int=0
    --unw-stack-scan-frames: int=5
    --error-limit: string@'nu-complete valgrind-yesno'
    --exit-on-first-error: string@'nu-complete valgrind-yesno'
]

# a wrapper for the `valgrind` command-line tool for debugging memory leaks and
# program performance degradations/crashes; see https://valgrind.org for more
# information
export def --wrapped main [
    cls: closure
    ...args: string
] {
    (^valgrind (do $cls ...$args))
}
