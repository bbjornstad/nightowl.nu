# ╓──────────────────────────────────────────────────────────────────────╖
# ║ Git Subtree Workflow                                                 ║
# ╙──────────────────────────────────────────────────────────────────────╜
# defines a set of commands, which are subcommands of git, and which will allow
# the user to manipulate/manage git repositories and specifically any subtree
# inclusions that are used. For more information about subtrees and the subtree
# workflow, please see the following link:
# https://www.atlassian.com/git/tutorials/git-subtree

#
export def main [
    name: string
    branch: string@(git branch)
] {
    git subtree $in
}

export def "main update" [
    name: string="nufmt",
    branch: string="main"
] {
    let path = ($nu.default-config-dir | path join "utils" "nufmt")
        let id = (["nushell" $name ] | str join "-")
        let gitdir = ($nu.default-config-dir | path join ".git")
        (git
         --work-tree $nu.default-config-dir
         --git-dir $gitdir
         subtree pull --prefix $path $id $branch)
}
