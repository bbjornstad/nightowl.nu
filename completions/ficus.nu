#!/usr/bin/env nu

export extern toilet [
    message?: string # a message to turn into an ASCII banner
    --font (-f): string # figlet or toilet font name
    --directory (-d): directory # directory in which to search for fonts
    -S # render with nicely set smushing
    -k # render with kerning (as close as possible)
    -W # render with full width
    -o # render with allowance of overlaps
    -s # render with font's default smushing behavior
    --width (-w): int # target output width in number of column
    --termwidth (-t) # set target output width to terminal width
    --filter (-F): list<string> # a list of filters applied to output, separated with colons
    --rainbow # shortcut to commonly used rainbow filter
    --metal # shortcut to commonly used metal filter
    --export (-E): list<string> # output format specification, as recongized by libcaca
    --irc # set output format to IRC
    --html # set output format to HTMLs
    --help (-h) # command help
    --infocode (-I): int # a figlet information code
    --version # get version information
]

export extern figlet [
    message?: string # a message to turn into an ASCII banner
    --font (-f): string # figlet font name
    --fontdirectory (-d): directory # directory in which to search for fonts
    -c # place output aligned center horizontally
    -l # place output flush left
    -r # place output flush right
    -x # automatically set output justification based on whether the text is left to right or right to left
    -t # set target output width to terminal width
    -w: int # target output width in number of columns
    -p # use `paragraph-mode`; treats newlines as blanks between words--see `man figlet`
    -n # use `normal mode`; treats newlines normally and produces line breaks.
    -D # [deprecated] switch to german character set
    -E # [deprecated] switch back to normal character set
    -C: path # adds the given controlfile to the list of controlfiles present--see `man figlet`
    -N # clear the list of controlfiles.
    -S # render with nicely set smushing
    -k # render with kerning (as close as possible)
    -W # render with full width
    -o # render with allowance of overlaps
    -s # render with font's default smushing behavior
    -m: int # a layout mode between 1-63--see `man figlet`
    -L # set printing mode left-to-right
    -R # set printing mode right-to-left
    -X # use the printing mode specified in the font file
    -v # get version information
    -I: int # figlet information code for status output--see `man figlet`
]
