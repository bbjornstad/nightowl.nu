#!/usr/bin/env nu
# vim: set ft=nu:

let dawnfox_theme = {
   binary: "#d7827e"
   block: "#625c87"
   bool: "#ca6e69"
   cellpath: "#575279"
   date: "#618774"
   duration: "#618774"
   filesize: "#d7827e"
   float: "#d7827e"
   int: "#d7827e"
   list: "#625c87"
   nothing: "#575279"
   range: "#575279"
   record: "#575279"
   string: "#618774"

   leading_trailing_space_bg: "#ebdfe4"
   header: "#625c87"
   empty: "#286983"
   row_index: "#a8a3b3"
   hints: "#a8a3b3"
   separator: "#9893a5"

   shape_block: "#625c87"
   shape_bool: "#ca6e69"
   shape_external: "#907aa9"
   shape_externalarg: "#575279"
   shape_filepath: "#575279"
   shape_flag: "#56949f"
   shape_float: "#d7827e"
   shape_globpattern: "#dd9024"
   shape_int: "#d7827e"
   shape_internalcall: "#907aa9"
   shape_list: "#625c87"
   shape_literal: "#618774"
   shape_nothing: "#50848c"
   shape_operator: "#625c87"
   shape_record: "#625c87"
   shape_string: "#618774"
   shape_string_interpolation: "#dd9024"
   shape_table: "#625c87"
   shape_variable: "#575279"
}

$env.config = ($env.config | upsert "color_config" $dawnfox_theme)
