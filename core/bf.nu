#!/usr/bin/env nu
# vim: set ft=nu:
const shell = "/usr/bin/env nu"
const this_editor = "/usr/bin/env nvim"
const default_file = "~/.config/butterfish/prompt.txt"

def bf-subcommands [] {
    ["shell" "promptedit" "prompt" "edit" "summarize" "gencmd" "exec" "index"]
}

export extern butterfish [
    command: string@bf-subcommands                     # subcommand of butterfish
    --help(-h)                                         # display help for this command
    --verbose(-v)                                      # toggle verbose output
    --log(-L)                                          # write verbose output to a log file, usually /var/tmp/butterfish.log
    --version(-V)                                      # display version information and then quit
    --base-url(-u): string="https://api.openai.com/v1" # url to a server with openAI compatible API; see `butterfish --help`
]

export extern "butterfish shell" [
    --bin(-b): string=$shell                                 # Shell to use (e.g. /bin/zsh), defaults to $SHELL
    --model(-m): string="gpt-3.5-turbo-1106"                 # Model for when the user manually enters a prompt
    --autosuggest-disabled(-A)                               # Disable autosuggest
    --autosuggest-model(-a): string="gpt-3.5-turbo-instruct" # Model for autosuggest
    --autosuggest-timeout(-t): int=500                       # Delay in milliseconds after typing before autosuggest (lower values trigger more calls and are more expensive)
    --newline-autosuggest-timeout(-T): int=3500              # Timeout in milliseconds for autosuggest on a fresh line, i.e. before a command has started; negative values disable
    --no-command-prompt(-p)                                  # Don't change command prompt (shell PS1 variable). If not set, an emoji will be added to the prompt as a reminder you're in Shell Mode
    --light-color(-l)                                        # Light color mode, appropriate for a terminal with a white(ish) background
    --max-history-block-tokens(-H): int=512                  # Maximum number of tokens of each block of history. For example, if a command has a very long output, it will be truncated to this length when sending the shell's history
]

export extern "butterfish promptedit" [
    --model(-m): string="gpt-3.5-turbo-1106" # LLM to use for the prompt
    --editor(-e): path=$this_editor          # editor to use to edit the prompt, defaults to neovim
    --file(-f): path=$default_file           # filepath of file containing prompt or name of new file
    --num-tokens(-n): int=1024               # Maximum number of tokens to generate
    --temperature(-T): float=0.7             # Temperature to use for the prompt, higher temperature indicates more freedom/randomness when generating each token
]

export extern "butterfish edit" [
    filepath: path                           # a file to edit
    prompt: string                           # an LLM model prompt
    --model(-m): string="gpt-3.5-turbo-1106" # LLM to use for the prompt
    --num-tokens(-n): int=1024               # Maximum number of tokens to generate
    --temperature(-T): float=0.7             # Temperature to use for the prompt, higher temperature indicates more freedom/randomness when generating each token
    --in-place(-I)                           # edit the file in place, otherwise stdout is used
    --no-color                               # Disable color output
    --no-backticks                           # Strip out backticks around codeblocks
]

export extern "butterfish summarize" [
    ...files: path             # file items to generate a summary of
    --chunk-size(-c): int=3600 # Number of bytes to summarize at a time if the file must be split up
    --max-chunks(-C): int=8    # Maximum number of chunks to summarize from a specific file
]

export extern "butterfish gencmd" [
    prompt: string
    --force(-f) # forcefully execute the command without prompting
]

export extern "butterfish exec" [
    command: string
]

export extern "butterfish index" [
    ...paths: path            # collection of paths to add to embedding index
    --force(-f)               # Force re-indexing of files rather than skipping cached embeddings
    --chunk-size(-c): int=512 # Number of bytes to embed at a time when the file is split up
    --max-chunks(-C): int=256 # Maximum number of chunks to embed from a specific file
]

export def main [] {
    butterfish $in
}
