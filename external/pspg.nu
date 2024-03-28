#!/usr/bin/env nu
# vim: set ft=nu:
export def --wrapped main [...args] {
  let input = $in
  $env.config.ls.clickable_links = false
  $env.config.table.mode = rounded
  $env.config.table.header_on_separator = false
  $env.config.footer_mode = never
  $input | ^pspg ...$args
}
