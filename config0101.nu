$env.config.completions.algorithm = "Fuzzy"
$env.config.completions.partial = false
$env.config.completions.quick = false
$env.config.completions.use_ls_colors = false
$env.config.cursor_shape.emacs = "Line"
$env.config.cursor_shape.vi_insert = "Block"
$env.config.cursor_shape.vi_normal = "Underscore"
$env.config.footer_mode = "Always"
$env.config.highlight_resolved_externals = true
$env.config.history.file_format = "Sqlite"
$env.config.history.isolation = true
$env.config.history.max_size = 200000
$env.config.render_right_prompt_on_last_line = true
$env.config.show_banner = false
$env.config.table.header_on_separator = true
$env.config.table.show_empty = false
# $env.config.use_ansi_coloring = "True" # strange case appeared. Probably there is a bug in the code
$env.config.use_kitty_protocol = true

# The settings below don't have corresponding default values

$env.config.completions.external.completer = {|spans|
  # if the current command is an alias, get it's expansion
  let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)

  # overwrite
  let spans = (if $expanded_alias != null  {
    # put the first word of the expanded alias first in the span
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
  } else {
    $spans
  })

  carapace $spans.0 nushell ...$spans
  | from json
}
$env.config.table.abbreviated_row_count = 12
$env.config.color_config.binary = "white"
$env.config.color_config.block = "white"
$env.config.color_config.bool = "light_cyan"
$env.config.color_config.cell-path = "white"
$env.config.color_config.date = "purple"
$env.config.color_config.duration = "white"
$env.config.color_config.empty = "blue"
$env.config.color_config.filesize = "cyan"
$env.config.color_config.float = "white"
$env.config.color_config.header = "green_bold"
$env.config.color_config.hints = "dark_gray"
$env.config.color_config.int = "white"
$env.config.color_config.leading_trailing_space_bg.attr = "n"
$env.config.color_config.list = "white"
$env.config.color_config.nothing = "white"
$env.config.color_config.range = "white"
$env.config.color_config.record = "white"
$env.config.color_config.row_index = "green_bold"
$env.config.color_config.search_result.bg = "red"
$env.config.color_config.search_result.fg = "white"
$env.config.color_config.separator = "white"
$env.config.color_config.shape_and = "purple_bold"
$env.config.color_config.shape_binary = "purple_bold"
$env.config.color_config.shape_block = "blue_bold"
$env.config.color_config.shape_bool = "light_cyan"
$env.config.color_config.shape_closure = "green_bold"
$env.config.color_config.shape_custom = "green"
$env.config.color_config.shape_datetime = "cyan_bold"
$env.config.color_config.shape_directory = "cyan"
$env.config.color_config.shape_external = "cyan"
$env.config.color_config.shape_external_resolved = "light_yellow_bold"
$env.config.color_config.shape_externalarg = "green_bold"
$env.config.color_config.shape_filepath = "cyan"
$env.config.color_config.shape_flag = "blue_bold"
$env.config.color_config.shape_float = "purple_bold"
$env.config.color_config.shape_garbage.attr = "b"
$env.config.color_config.shape_garbage.bg = "red"
$env.config.color_config.shape_garbage.fg = "white"
$env.config.color_config.shape_glob_interpolation = "cyan_bold"
$env.config.color_config.shape_globpattern = "cyan_bold"
$env.config.color_config.shape_int = "purple_bold"
$env.config.color_config.shape_internalcall = "cyan_bold"
$env.config.color_config.shape_keyword = "cyan_bold"
$env.config.color_config.shape_list = "cyan_bold"
$env.config.color_config.shape_literal = "blue"
$env.config.color_config.shape_match_pattern = "green"
$env.config.color_config.shape_matching_brackets.attr = "u"
$env.config.color_config.shape_nothing = "light_cyan"
$env.config.color_config.shape_operator = "yellow"
$env.config.color_config.shape_or = "purple_bold"
$env.config.color_config.shape_pipe = "purple_bold"
$env.config.color_config.shape_range = "yellow_bold"
$env.config.color_config.shape_raw_string = "light_purple"
$env.config.color_config.shape_record = "cyan_bold"
$env.config.color_config.shape_redirection = "purple_bold"
$env.config.color_config.shape_signature = "green_bold"
$env.config.color_config.shape_string = "green"
$env.config.color_config.shape_string_interpolation = "cyan_bold"
$env.config.color_config.shape_table = "blue_bold"
$env.config.color_config.shape_vardecl = "purple"
$env.config.color_config.shape_variable = "purple"
$env.config.color_config.string = "white"
$env.config.explore.command_bar_text.fg = "#C4C9C6"
$env.config.explore.highlight.bg = "yellow"
$env.config.explore.highlight.fg = "black"
$env.config.explore.selected_cell.bg = "light_blue"
$env.config.explore.status.error.bg = "red"
$env.config.explore.status.error.fg = "white"
$env.config.explore.status_bar_background.bg = "#C4C9C6"
$env.config.explore.status_bar_background.fg = "#1D1F21"
$env.config.table.trim.truncating_suffix = "..."

#hooks

$env.config.hooks = {
    pre_prompt: [
        { null }
    ],
    pre_execution: [
        { null }
    ],
    env_change: {
        PWD: [
            { |before, after|
        #print $"before: [($before)], after: [($after)]"
        # print ($env.LS_COLORS)
        print (ls | sort-by type name -i | grid -c -i )
        # null
      },
            {
                condition: {|_, after| not ($after | path join 'toolkit.nu' | path exists)},
                code: "hide toolkit"
            },
            {
                condition: {|_, after| $after | path join 'toolkit.nu' | path exists},
                code: "
        print $'(ansi default_underline)(ansi default_bold)toolkit(ansi reset) module (ansi green_italic)detected(ansi reset)...'
        print $'(ansi yellow_italic)activating(ansi reset) (ansi default_underline)(ansi default_bold)toolkit(ansi reset) module with `(ansi default_dimmed)(ansi default_italic)use toolkit.nu(ansi reset)`'
        use toolkit.nu
        # overlay use --prefix toolkit.nu
        "
            },
            {|before, _|
        if $before == null {
            let file = ($nu.home-path | path join ".local" "share" "nushell" "startup-times.nuon")
            if not ($file | path exists) {
                mkdir ($file | path dirname)
                touch $file
            }
            let ver = (version)
            open $file | append {
                date: (date now)
                time: $nu.startup-time
                build: ($ver.build_rust_channel)
                allocator: ($ver.allocator)
                version: ($ver.version)
                commit: ($ver.commit_hash)
                build_time: ($ver.build_time)
                bytes_loaded: (view files | get size | math sum)
            } | collect { save --force $file }
        }
      }
        ]
    },
    display_output: {
            metadata access {|meta| match $meta.content_type? {
            "application/x-nuscript" | "application/x-nuon" | "text/x-nushell" => { nu-highlight },
            "application/json" => { ^bat --language=json --color=always --style=plain --paging=never },
            _ => {},
            }
        }
        | if (term size).columns >= 100 { table -e } else { table }
    },
    command_not_found: { null }
}

#menus

$env.config.menus ++= [{
    name: completion_menu,
    marker: "| ",
    only_buffer_difference: false,
    style: {
        text: green,
        selected_text: {
            attr: r
        },
        description_text: yellow,
        match_text: {
            attr: u
        },
        selected_match_text: {
            attr: ur
        }
    },
    type: {
        layout: columnar,
        columns: 4,
        col_width: 20,
        col_padding: 2
    },
    source: null
}]

$env.config.menus ++= [{
    name: ide_completion_menu,
    marker: "| ",
    only_buffer_difference: false,
    style: {
        text: green,
        selected_text: {
            attr: r
        },
        description_text: yellow,
        match_text: {
            attr: u
        },
        selected_match_text: {
            attr: ur
        }
    },
    type: {
        layout: ide,
        min_completion_width: 0,
        max_completion_width: 50,
        max_completion_height: 10,
        padding: 0,
        border: true,
        cursor_offset: 0,
        description_mode: prefer_right,
        min_description_width: 0,
        max_description_width: 50,
        max_description_height: 10,
        description_offset: 1,
        correct_cursor_pos: false
    },
    source: null
}]

$env.config.menus ++= [{
    name: history_menu,
    marker: "? ",
    only_buffer_difference: true,
    style: {
        text: green,
        selected_text: green_reverse,
        description_text: yellow
    },
    type: {
        layout: list,
        page_size: 10
    },
    source: null
}]

$env.config.menus ++= [{
    name: help_menu,
    marker: "? ",
    only_buffer_difference: true,
    style: {
        text: green,
        selected_text: green_reverse,
        description_text: yellow
    },
    type: {
        layout: description,
        columns: 4,
        col_width: 20,
        col_padding: 2,
        selection_rows: 4,
        description_rows: 10
    },
    source: null
}]

$env.config.menus ++= [{
    name: all_history_menu,
    marker: "? ",
    only_buffer_difference: true,
    style: {
        text: green,
        selected_text: green_reverse
    },
    type: {
        layout: list,
        page_size: 10
    },
    source: {|buffer, position|
                history
                | select command exit_status
                | where exit_status != 1
                | where command =~ $buffer
                | each {|it| {value: $it.command } }
                | reverse
                | uniq
            }
}]

$env.config.menus ++= [{
    name: vars_menu,
    marker: "# ",
    only_buffer_difference: true,
    style: {
        text: green,
        selected_text: green_reverse,
        description_text: yellow
    },
    type: {
        layout: list,
        page_size: 10
    },
    source: {|buffer, position|
            scope variables
            | where name not-in ($env.ignore-env-vars? | default [])
            | sort-by var_id -r
            | where name =~ $buffer
            | each {|it| {value: $it.name description: $it.type} }
        }
}]

$env.config.menus ++= [{
    name: pwd_history_menu,
    marker: "? ",
    only_buffer_difference: true,
    style: {
        text: green,
        selected_text: green_reverse
    },
    type: {
        layout: list,
        page_size: 25
    },
    source: {|buffer, position|
            history
            | select command exit_status cwd
            | where exit_status != 1
            | where cwd == $env.PWD
            | where command =~ $buffer
            | each {|it| {value: $it.command } }
            | reverse
            | uniq
        }
}]

$env.config.menus ++= [{
    name: current_session_menu,
    marker: "# ",
    only_buffer_difference: false,
    style: {
        text: green,
        selected_text: green_reverse,
        description_text: yellow
    },
    type: {
        layout: list,
        page_size: 10
    },
    source: {|buffer, position|
            history -l
            | where session_id == (history session)
            | select command
            | where command =~ $buffer
            | each {|it| {value: $it.command } }
            | reverse
            | uniq
        }
}]

$env.config.menus ++= [{
    name: pipe_completions_menu,
    marker: "# ",
    only_buffer_difference: false,
    style: {
        text: green,
        selected_text: green_reverse,
        description_text: yellow
    },
    type: {
        layout: list,
        page_size: 25
    },
    source: {|buffer, position|

            let esc_regex: closure = {|i|
                let $input = $i
                let $regex_special_symbols = [\\, \., \^, "\\$", \*, \+, \?, "\\{", "\\}", "\\(", "\\)", "\\[", "\\]", "\\|", \/]

                $regex_special_symbols
                | str replace '\' ''
                | zip $regex_special_symbols
                | reduce -f $input {|i acc| $acc | str replace -a $i.0 $i.1}
            }

            let $segments = $buffer | split row -r '(\s\|\s)|\(|;|(\{\|\w\| )'
            let $last_segment = $segments | last
            let $last_segment_esc = do $esc_regex $last_segment
            let $smt = $buffer | str replace -r $'($last_segment_esc)$' ' '

            history
            | get command
            | uniq
            | where $it =~ $last_segment_esc
            | each {
                str replace -a (char nl) ' '
                | str replace -r $'.*($last_segment_esc)' $last_segment
                | $"($smt)($in)"
            }
            | reverse
            | uniq
            | each {|it| {value: $it}}
        }
}]

$env.config.menus ++= [{
    name: working_dirs_cd_menu,
    marker: "? ",
    only_buffer_difference: true,
    style: {
        text: green,
        selected_text: green_reverse
    },
    type: {
        layout: list,
        page_size: 23
    },
    source: {|buffer, position|
            open $nu.history-path
            | query db "SELECT DISTINCT(cwd) FROM history ORDER BY id DESC"
            | get CWD
            | where $it =~ $buffer
            | each {|it| {value: $it}}
        }
}]

#keybidnings

$env.config.keybindings ++= [{
    name: completion_next_menu,
    modifier: none,
    keycode: tab,
    event: {
        until: [
            {
                send: menu,
                name: completion_menu
            },
            {
                send: menunext
            },
            {
                edit: complete
            }
        ]
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: completion_previous_menu,
    modifier: shift,
    keycode: backtab,
    event: {
        send: menuprevious
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: ide_completion_menu,
    modifier: control,
    keycode: char_n,
    event: {
        until: [
            {
                send: menu,
                name: ide_completion_menu
            },
            {
                send: menunext
            },
            {
                edit: complete
            }
        ]
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: help_menu,
    modifier: none,
    keycode: "f1",
    event: {
        send: menu,
        name: help_menu
    },
    mode: [
        emacs,
        vi_insert,
        vi_normal
    ]
}]

$env.config.keybindings ++= [{
    name: next_page_menu,
    modifier: control,
    keycode: char_x,
    event: {
        send: menupagenext
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: undo_or_previous_page_menu,
    modifier: control,
    keycode: char_z,
    event: {
        until: [
            {
                send: menupageprevious
            },
            {
                edit: undo
            }
        ]
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: escape,
    modifier: none,
    keycode: escape,
    event: {
        send: esc
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: cancel_command,
    modifier: control,
    keycode: char_c,
    event: {
        send: ctrlc
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: quit_shell,
    modifier: control,
    keycode: char_d,
    event: {
        send: ctrld
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: clear_screen,
    modifier: control,
    keycode: char_l,
    event: {
        send: clearscreen
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: search_history,
    modifier: control,
    keycode: char_q,
    event: {
        send: searchhistory
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: open_command_editor,
    modifier: control,
    keycode: char_o,
    event: {
        send: openeditor
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_up,
    modifier: none,
    keycode: up,
    event: {
        until: [
            [
                        send
            ];
            [
                menuup
            ],
            [
                up
            ]
        ]
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_down,
    modifier: none,
    keycode: down,
    event: {
        until: [
            [
                        send
            ];
            [
                menudown
            ],
            [
                down
            ]
        ]
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_left,
    modifier: none,
    keycode: left,
    event: {
        until: [
            [
                        send
            ];
            [
                menuleft
            ],
            [
                left
            ]
        ]
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_right_or_take_history_hint,
    modifier: none,
    keycode: right,
    event: {
        until: [
            [
                        send
            ];
            [
                historyhintcomplete
            ],
            [
                menuright
            ],
            [
                right
            ]
        ]
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_one_word_left,
    modifier: control,
    keycode: left,
    event: {
        edit: movewordleft
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_one_word_right_or_take_history_hint,
    modifier: control,
    keycode: right,
    event: {
        until: [
            {
                send: historyhintwordcomplete
            },
            {
                edit: movewordright
            }
        ]
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_to_line_start,
    modifier: none,
    keycode: home,
    event: {
        edit: movetolinestart
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_to_line_end_or_take_history_hint,
    modifier: none,
    keycode: end,
    event: {
        until: [
            {
                send: historyhintcomplete
            },
            {
                edit: movetolineend
            }
        ]
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_to_line_end_or_take_history_hint,
    modifier: control,
    keycode: char_e,
    event: {
        until: [
            {
                send: historyhintcomplete
            },
            {
                edit: movetoend
            }
        ]
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_to_line_start,
    modifier: control,
    keycode: home,
    event: {
        edit: movetolinestart
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_to_line_end,
    modifier: control,
    keycode: end,
    event: {
        edit: movetolineend
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_up,
    modifier: control,
    keycode: char_p,
    event: {
        until: [
            [
                        send
            ];
            [
                menuup
            ],
            [
                up
            ]
        ]
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: delete_one_character_backward,
    modifier: none,
    keycode: backspace,
    event: {
        edit: backspace
    },
    mode: [
        emacs,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: delete_one_word_backward,
    modifier: control,
    keycode: backspace,
    event: {
        edit: backspaceword
    },
    mode: [
        emacs,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: delete_one_character_forward,
    modifier: none,
    keycode: delete,
    event: {
        edit: delete
    },
    mode: [
        emacs,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: delete_one_character_forward,
    modifier: control,
    keycode: delete,
    event: {
        edit: delete
    },
    mode: [
        emacs,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: delete_one_character_backward,
    modifier: control,
    keycode: char_h,
    event: {
        edit: backspace
    },
    mode: [
        emacs,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: move_left,
    modifier: none,
    keycode: backspace,
    event: {
        edit: moveleft
    },
    mode: vi_normal
}]

$env.config.keybindings ++= [{
    name: newline_or_run_command,
    modifier: none,
    keycode: enter,
    event: {
        send: enter
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: move_left,
    modifier: control,
    keycode: char_b,
    event: {
        until: [
            [
                        send
            ];
            [
                menuleft
            ],
            [
                left
            ]
        ]
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: redo_change,
    modifier: control,
    keycode: char_g,
    event: {
        edit: redo
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: undo_change,
    modifier: control,
    keycode: char_z,
    event: {
        edit: undo
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: paste_before,
    modifier: control,
    keycode: char_y,
    event: {
        edit: pastecutbufferbefore
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: cut_word_left,
    modifier: control,
    keycode: char_w,
    event: {
        edit: cutwordleft
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: cut_line_to_end,
    modifier: control,
    keycode: char_k,
    event: {
        edit: cuttoend
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: cut_line_from_start,
    modifier: control,
    keycode: char_u,
    event: {
        edit: cutfromstart
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: swap_graphemes,
    modifier: control_alt,
    keycode: char_t,
    event: {
        edit: swapgraphemes
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: move_one_word_left,
    modifier: alt,
    keycode: left,
    event: {
        edit: movewordleft
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: move_one_word_right_or_take_history_hint,
    modifier: alt,
    keycode: right,
    event: {
        until: [
            {
                send: historyhintwordcomplete
            },
            {
                edit: movewordright
            }
        ]
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: move_one_word_left,
    modifier: alt,
    keycode: char_b,
    event: {
        edit: movewordleft
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: delete_one_word_forward,
    modifier: alt,
    keycode: delete,
    event: {
        edit: deleteword
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: delete_one_word_backward,
    modifier: alt,
    keycode: backspace,
    event: {
        edit: backspaceword
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: delete_one_word_backward,
    modifier: alt,
    keycode: char_m,
    event: {
        edit: backspaceword
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: cut_word_to_right,
    modifier: alt,
    keycode: char_d,
    event: {
        edit: cutwordright
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: upper_case_word,
    modifier: alt,
    keycode: char_u,
    event: {
        edit: uppercaseword
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: lower_case_word,
    modifier: alt,
    keycode: char_l,
    event: {
        edit: lowercaseword
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: capitalize_char,
    modifier: alt,
    keycode: char_c,
    event: {
        edit: capitalizechar
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: copy_selection,
    modifier: control_shift,
    keycode: char_c,
    event: {
        edit: copyselection
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: cut_selection,
    modifier: control_shift,
    keycode: char_x,
    event: {
        edit: cutselection
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: select_all,
    modifier: control_shift,
    keycode: char_a,
    event: {
        edit: selectall
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: move_to__start,
    modifier: control,
    keycode: char_a,
    event: {
        edit: movetostart
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: insert_newline,
    modifier: alt,
    keycode: enter,
    event: {
        edit: insertnewline
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: paste,
    modifier: control_shift,
    keycode: char_v,
    event: {
        edit: pastecutbufferbefore
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: vars_menu,
    modifier: alt,
    keycode: char_o,
    event: {
        send: menu,
        name: vars_menu
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: "pwd history",
    modifier: control,
    keycode: char_h,
    event: {
        send: menu,
        name: pwd_history_menu
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: current_session_menu,
    modifier: alt,
    keycode: char_r,
    event: {
        send: menu,
        name: current_session_menu
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: pipe_completions_menu,
    modifier: shift_alt,
    keycode: char_s,
    event: {
        send: menu,
        name: pipe_completions_menu
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: working_dirs_cd_menu,
    modifier: alt_shift,
    keycode: char_r,
    event: {
        send: menu,
        name: working_dirs_cd_menu
    },
    mode: emacs
}]

$env.config.keybindings ++= [{
    name: prompt_to_raw_string,
    modifier: control,
    keycode: char_v,
    event: {
        send: executehostcommand,
        cmd: "        let input = commandline;
        let hashes = $input | parse -r '(#+)' | get capture0 | sort -r | get 0? | default '';
        $\" r#($hashes)'($input)'#($hashes) | prompt \" | commandline edit -r $in
"
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: fzf_history_entries,
    modifier: control,
    keycode: char_f,
    event: {
        send: executehostcommand,
        cmd: "        let $index_sep = \"\\u{200C}\\t\"
        let $entry_sep = \"\\u{200B}\"

        open $nu.history-path
        | query db '
            WITH ordered_history AS (
                SELECT
                    id,
                    command_line,
                    ROW_NUMBER() OVER (PARTITION BY command_line ORDER BY id DESC) AS row_num
                FROM history
            )
            SELECT
                id,
                command_line
            FROM ordered_history
            WHERE row_num = 1
            ORDER BY id DESC;
        '
        | each {$\"($in.id)($index_sep)($in.command_line)\"}
        | str join (char nul)
        | ($in | fzf --cycle --read0 --print0
            --bind='ctrl-r:toggle-sort'
            --delimiter=$'($index_sep)'
            --height=70%
            --layout=reverse
            --multi
            --preview-window='bottom:30%:wrap'
            --preview=\" echo {2} | nu -n --no-std-lib --stdin -c 'nu-highlight' \"
            --tiebreak=begin,length,chunk
            --with-shell='bash -c '
            --wrap
            --wrap-sign \"\\t↳ \"
            -n2..
        )
        | decode utf-8
        | str trim --char (char nl)
        | str replace -ar $'(char lp)^|(char nul)(char rp)\\d+?($index_sep)' '$1'
        | str replace -ar (char nul) $';(char nl)'
        | str replace -a $entry_sep '    '
        | str trim
        | commandline edit --append $in
        | commandline set-cursor -e
"
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: fzf_history,
    modifier: alt,
    keycode: char_f,
    event: {
        send: executehostcommand,
        cmd: "        open $nu.history-path
        | query db '
            WITH ordered_history AS (
                SELECT command_line
                FROM history
                ORDER BY id DESC
            )
            SELECT DISTINCT command_line
            FROM ordered_history;
        '
        | get command_line
        | each { str replace -a '    ' \"\\u{200B}\" }
        | str join (char nul)
        | fzf --cycle --scheme=history --read0 --print0 --tiebreak=begin,length,chunk --layout=reverse --multi --with-shell='sh -c' --preview=\"echo {..}\" --preview-window='bottom:3:wrap' --height=70% --query=$'^(commandline | str replace -a \"| \" \"\")' --wrap --header=\"ctrl-r to disable sort\" --header-first
        | decode utf-8
        | str trim --char (char nl)
        | str replace -ar (char nul) $';(char nl)'
        | str replace -a \"\\u{200B}\" '    '
        | str trim
        | commandline edit --replace $in
        | commandline set-cursor -e
"
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: fzf_history_sessions,
    modifier: alt_control,
    keycode: char_f,
    event: {
        send: executehostcommand,
        cmd: "        open $nu.history-path
        | query db -p [
            (commandline | split row -r $';(char nl)?' | str trim | compact --empty | to json)
        ] \"
            WITH json_values AS (
                SELECT value
                FROM json_each(?)
            )
            SELECT DISTINCT command_line
            FROM history AS session_history
            WHERE EXISTS (
                SELECT 1
                FROM json_values
                WHERE session_history.command_line LIKE '%' || json_values.value || '%'
            )
        \"
        | get command_line
        | each { str replace -a '    ' \"\\u{200B}\" }
        | str join (char nul)
        | fzf --cycle --no-sort --read0 --print0 --tiebreak=begin,length,chunk --layout=reverse --multi --with-shell='sh -c' --preview=\"echo {..}\" --preview-window='bottom:3:wrap' --height=70% --wrap
        | decode utf-8
        | str trim --char (char nl)
        | str replace -ar (char nul) $';(char nl)'
        | str replace -a \"\\u{200B}\" '    '
        | str trim
        | commandline edit -a $in
        | commandline set-cursor -e
"
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: copy_command,
    modifier: control_alt,
    keycode: char_c,
    event: {
        send: executehostcommand,
        cmd: "commandline | pbcopy; commandline edit --append ' # copied'"
    },
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]

$env.config.keybindings ++= [{
    name: broot_path_completion,
    modifier: control,
    keycode: char_t,
    event: [
        [
                send,
                cmd
        ];
        [
            ExecuteHostCommand,
            "        let $cl = commandline
        let $pos = commandline get-cursor

        let $element = return-cline-element $cl $pos

        let $path_exp = $element
            | str trim -c '\"'
            | str trim -c \"'\"
            | str trim -c '`'
            | if $in =~ '^~' { path expand } else {}
            | if ($in | path exists) {} else {'.'}

        let $broot_path = ^broot $path_exp --conf ($env.XDG_CONFIG_HOME | path join broot select.hjson)
            | if ' ' in $in { $\"`($in)`\" } else {}

        if $path_exp == '.' {
            commandline edit --insert $broot_path
        } else {
            $cl | str replace $element $broot_path | commandline edit -r $in
        }
"
        ]
    ],
    mode: [
        emacs,
        vi_normal,
        vi_insert
    ]
}]
# Your old config is below. Uncomment what is needed, delete redundant.

# # Nushell Config File
# #
# # version = "0.100.0"
#
# # For more information on defining custom themes, see
# # https://www.nushell.sh/book/coloring_and_theming.html
# # And here is the theme collection
# # https://github.com/nushell/nu_scripts/tree/main/themes
# let dark_theme = {
#     # color for nushell primitives
#     separator: white
#     leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
#     header: green_bold
#     empty: blue
#     # Closures can be used to choose colors for specific values.
#     # The value (in this case, a bool) is piped into the closure.
#     # eg) {|| if $in { 'light_cyan' } else { 'light_gray' } }
#     bool: light_cyan
#     int: white
#     filesize: cyan
#     duration: white
#     date: purple
#     range: white
#     float: white
#     string: white
#     nothing: white
#     binary: white
#     cell-path: white
#     row_index: green_bold
#     record: white
#     list: white
#     block: white
#     hints: dark_gray
#     search_result: { bg: red fg: white }
#     shape_and: purple_bold
#     shape_binary: purple_bold
#     shape_block: blue_bold
#     shape_bool: light_cyan
#     shape_closure: green_bold
#     shape_custom: green
#     shape_datetime: cyan_bold
#     shape_directory: cyan
#     shape_external: cyan
#     shape_externalarg: green_bold
#     shape_external_resolved: light_yellow_bold
#     shape_filepath: cyan
#     shape_flag: blue_bold
#     shape_float: purple_bold
#     # shapes are used to change the cli syntax highlighting
#     shape_garbage: { fg: white bg: red attr: b }
#     shape_glob_interpolation: cyan_bold
#     shape_globpattern: cyan_bold
#     shape_int: purple_bold
#     shape_internalcall: cyan_bold
#     shape_keyword: cyan_bold
#     shape_list: cyan_bold
#     shape_literal: blue
#     shape_match_pattern: green
#     shape_matching_brackets: { attr: u }
#     shape_nothing: light_cyan
#     shape_operator: yellow
#     shape_or: purple_bold
#     shape_pipe: purple_bold
#     shape_range: yellow_bold
#     shape_record: cyan_bold
#     shape_redirection: purple_bold
#     shape_signature: green_bold
#     shape_string: green
#     shape_string_interpolation: cyan_bold
#     shape_table: blue_bold
#     shape_variable: purple
#     shape_vardecl: purple
#     shape_raw_string: light_purple
# }
#
# let light_theme = {
#     # color for nushell primitives
#     separator: dark_gray
#     leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
#     header: green_bold
#     empty: blue
#     # Closures can be used to choose colors for specific values.
#     # The value (in this case, a bool) is piped into the closure.
#     # eg) {|| if $in { 'dark_cyan' } else { 'dark_gray' } }
#     bool: dark_cyan
#     int: dark_gray
#     filesize: cyan_bold
#     duration: dark_gray
#     date: purple
#     range: dark_gray
#     float: dark_gray
#     string: dark_gray
#     nothing: dark_gray
#     binary: dark_gray
#     cell-path: dark_gray
#     row_index: green_bold
#     record: dark_gray
#     list: dark_gray
#     block: dark_gray
#     hints: dark_gray
#     search_result: { fg: white bg: red }
#     shape_and: purple_bold
#     shape_binary: purple_bold
#     shape_block: blue_bold
#     shape_bool: light_cyan
#     shape_closure: green_bold
#     shape_custom: green
#     shape_datetime: cyan_bold
#     shape_directory: cyan
#     shape_external: cyan
#     shape_externalarg: green_bold
#     shape_external_resolved: light_purple_bold
#     shape_filepath: cyan
#     shape_flag: blue_bold
#     shape_float: purple_bold
#     # shapes are used to change the cli syntax highlighting
#     shape_garbage: { fg: white bg: red attr: b }
#     shape_glob_interpolation: cyan_bold
#     shape_globpattern: cyan_bold
#     shape_int: purple_bold
#     shape_internalcall: cyan_bold
#     shape_keyword: cyan_bold
#     shape_list: cyan_bold
#     shape_literal: blue
#     shape_match_pattern: green
#     shape_matching_brackets: { attr: u }
#     shape_nothing: light_cyan
#     shape_operator: yellow
#     shape_or: purple_bold
#     shape_pipe: purple_bold
#     shape_range: yellow_bold
#     shape_record: cyan_bold
#     shape_redirection: purple_bold
#     shape_signature: green_bold
#     shape_string: green
#     shape_string_interpolation: cyan_bold
#     shape_table: blue_bold
#     shape_variable: purple
#     shape_vardecl: purple
#     shape_raw_string: light_purple
# }
#
# # External completer example
# # let carapace_completer = {|spans|
# #     carapace $spans.0 nushell ...$spans | from json
# # }
#
#
# let carapace_completer = {|spans|
#   # if the current command is an alias, get it's expansion
#   let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)
#
#   # overwrite
#   let spans = (if $expanded_alias != null  {
#     # put the first word of the expanded alias first in the span
#     $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
#   } else {
#     $spans
#   })
#
#   carapace $spans.0 nushell ...$spans
#   | from json
# }
#
#
# # The default config record. This is where much of your global configuration is setup.
# $env.config = {
#     show_banner: false # true or false to enable or disable the welcome banner at startup
#
#     ls: {
#         use_ls_colors: true # use the LS_COLORS environment variable to colorize output
#         clickable_links: true # enable or disable clickable links. Your terminal has to support links.
#     }
#
#     rm: {
#         always_trash: false # always act as if -t was given. Can be overridden with -p
#     }
#
#     table: {
#         mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
#         index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
#         show_empty: false # show 'empty list' and 'empty record' placeholders for command output
#         padding: { left: 1, right: 1 } # a left right padding of each column in a table
#         trim: {
#             methodology: truncating # wrapping or truncating
#             # wrapping_try_keep_words: false # A strategy used by the 'wrapping' methodology
#             truncating_suffix: "..." # A suffix used by the 'truncating' methodology
#         }
#         header_on_separator: true # show header text on separator/border line
#         abbreviated_row_count: 12 # limit data rows from top and bottom after reaching a set point
#     }
#
#     error_style: "fancy" # "fancy" or "plain" for screen reader-friendly error messages
#
#     # Whether an error message should be printed if an error of a certain kind is triggered.
#     display_errors: {
#         exit_code: false # assume the external command prints an error message
#         # Core dump errors are always printed, and SIGPIPE never triggers an error.
#         # The setting below controls message printing for termination by all other signals.
#         termination_signal: true
#     }
#
#     # datetime_format determines what a datetime rendered in the shell would look like.
#     # Behavior without this configuration point will be to "humanize" the datetime display,
#     # showing something like "a day ago."
#     datetime_format: {
#         # normal: '%a, %d %b %Y %H:%M:%S %z'    # shows up in displays of variables or other datetime's outside of tables
#         # table: '%m/%d/%y %I:%M:%S%p'          # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
#     }
#
#     explore: {
#         status_bar_background: { fg: "#1D1F21", bg: "#C4C9C6" },
#         command_bar_text: { fg: "#C4C9C6" },
#         highlight: { fg: "black", bg: "yellow" },
#         status: {
#             error: { fg: "white", bg: "red" },
#             warn: {}
#             info: {}
#         },
#             selected_cell: { bg: light_blue },
#     }
#
#     history: {
#         max_size: 200_000 # Session has to be reloaded for this to take effect
#         sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
#         file_format: "sqlite" # "sqlite" or "plaintext"
#         isolation: true # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
#     }
#
#     completions: {
#         case_sensitive: false # set to true to enable case-sensitive completions
#         quick: false    # set this to false to prevent auto-selecting completions when only one remains
#         partial: false # set this to false to prevent partial filling of the prompt
#         algorithm: "fuzzy"    # prefix or fuzzy
#         sort: "smart" # "smart" (alphabetical for prefix matching, fuzzy score for fuzzy matching) or "alphabetical"
#         external: {
#             enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
#             max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
#             completer: $carapace_completer # check 'carapace_completer' above as an example
#         }
#         use_ls_colors: false # set this to true to enable file/path/directory completions using LS_COLORS
#     }
#
#     filesize: {
#         metric: false # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
#         format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, auto
#     }
#
#     cursor_shape: {
#         emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
#         vi_insert: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
#         vi_normal: underscore # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
#     }
#
#     color_config: $dark_theme # if you want a more interesting theme, you can replace the empty record with `$dark_theme`, `$light_theme` or another custom record
#     footer_mode: always # always, never, number_of_rows, auto
#     float_precision: 2 # the precision for displaying floats in tables
#     # buffer_editor: "" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
#     use_ansi_coloring: true
#     bracketed_paste: true # enable bracketed paste, currently useless on windows
#     edit_mode: emacs # emacs, vi
#     shell_integration: {
#         # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
#         osc2: true
#         # osc7 is a way to communicate the path to the terminal, this is helpful for spawning new tabs in the same directory
#         osc7: true
#         # osc8 is also implemented as the deprecated setting ls.show_clickable_links, it shows clickable links in ls output if your terminal supports it. show_clickable_links is deprecated in favor of osc8
#         osc8: true
#         # osc9_9 is from ConEmu and is starting to get wider support. It's similar to osc7 in that it communicates the path to the terminal
#         osc9_9: false
#         # osc133 is several escapes invented by Final Term which include the supported ones below.
#         # 133;A - Mark prompt start
#         # 133;B - Mark prompt end
#         # 133;C - Mark pre-execution
#         # 133;D;exit - Mark execution finished with exit code
#         # This is used to enable terminals to know where the prompt is, the command is, where the command finishes, and where the output of the command is
#         osc133: true
#         # osc633 is closely related to osc133 but only exists in visual studio code (vscode) and supports their shell integration features
#         # 633;A - Mark prompt start
#         # 633;B - Mark prompt end
#         # 633;C - Mark pre-execution
#         # 633;D;exit - Mark execution finished with exit code
#         # 633;E - Explicitly set the command line with an optional nonce
#         # 633;P;Cwd=<path> - Mark the current working directory and communicate it to the terminal
#         # and also helps with the run recent menu in vscode
#         osc633: true
#         # reset_application_mode is escape \x1b[?1l and was added to help ssh work better
#         reset_application_mode: true
#     }
#     render_right_prompt_on_last_line: true # true or false to enable or disable right prompt to be rendered on last line of the prompt.
#     use_kitty_protocol: true # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.
#     highlight_resolved_externals: true # true enables highlighting of external commands in the repl resolved by which.
#     recursion_limit: 50 # the maximum number of times nushell allows recursion before stopping it
#
#     plugins: {} # Per-plugin configuration. See https://www.nushell.sh/contributor-book/plugins.html#configuration.
#
#     plugin_gc: {
#         # Configuration for plugin garbage collection
#         default: {
#             enabled: true # true to enable stopping of inactive plugins
#             stop_after: 10sec # how long to wait after a plugin is inactive to stop it
#         }
#         plugins: {
#             # alternate configuration for specific plugins, by name, for example:
#             #
#             # gstat: {
#             #     enabled: false
#             # }
#         }
#     }
#
#     hooks: {
#         pre_prompt: [{ null }] # run before the prompt is shown
#         pre_execution: [{ null }] # run before the repl input is run
#         env_change: {
#
#       PWD: [
#       { |before, after|
#         #print $"before: [($before)], after: [($after)]"
#         # print ($env.LS_COLORS)
#         print (ls | sort-by type name -i | grid -c -i )
#         # null
#       },
#       {
#         condition: {|_, after| not ($after | path join 'toolkit.nu' | path exists)}
#         code: "hide toolkit"
#         # code: "overlay hide --keep-env [ PWD ] toolkit"
#       },
#       {
#         condition: {|_, after| $after | path join 'toolkit.nu' | path exists}
#         code: "
#         print $'(ansi default_underline)(ansi default_bold)toolkit(ansi reset) module (ansi green_italic)detected(ansi reset)...'
#         print $'(ansi yellow_italic)activating(ansi reset) (ansi default_underline)(ansi default_bold)toolkit(ansi reset) module with `(ansi default_dimmed)(ansi default_italic)use toolkit.nu(ansi reset)`'
#         use toolkit.nu
#         # overlay use --prefix toolkit.nu
#         "
#       },
#       {|before, _|
#         if $before == null {
#             let file = ($nu.home-path | path join ".local" "share" "nushell" "startup-times.nuon")
#             if not ($file | path exists) {
#                 mkdir ($file | path dirname)
#                 touch $file
#             }
#             let ver = (version)
#             open $file | append {
#                 date: (date now)
#                 time: $nu.startup-time
#                 build: ($ver.build_rust_channel)
#                 allocator: ($ver.allocator)
#                 version: ($ver.version)
#                 commit: ($ver.commit_hash)
#                 build_time: ($ver.build_time)
#                 bytes_loaded: (view files | get size | math sum)
#             } | collect { save --force $file }
#         }
#       }
#       ]
#
#         }
#         display_output: {
#             metadata access {|meta| match $meta.content_type? {
#             "application/x-nuscript" | "application/x-nuon" | "text/x-nushell" => { nu-highlight },
#             "application/json" => { ^bat --language=json --color=always --style=plain --paging=never },
#             _ => {},
#             }
#         }
#         | if (term size).columns >= 100 { table -e } else { table }
#     }
#
#         # run to display the output of a pipeline
#         command_not_found: { null } # return an error message when a command is not found
#     }
#
#     menus: [
#         # Configuration for default nushell menus
#         # Note the lack of source parameter
#         {
#             name: completion_menu
#             only_buffer_difference: false
#             marker: "| "
#             type: {
#                 layout: columnar
#                 columns: 4
#                 col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
#                 col_padding: 2
#             }
#             style: {
#                 text: green
#                 selected_text: { attr: r }
#                 description_text: yellow
#                 match_text: { attr: u }
#                 selected_match_text: { attr: ur }
#             }
#         }
#         {
#             name: ide_completion_menu
#             only_buffer_difference: false
#             marker: "| "
#             type: {
#                 layout: ide
#                 min_completion_width: 0,
#                 max_completion_width: 50,
#                 max_completion_height: 10, # will be limited by the available lines in the terminal
#                 padding: 0,
#                 border: true,
#                 cursor_offset: 0,
#                 description_mode: "prefer_right"
#                 min_description_width: 0
#                 max_description_width: 50
#                 max_description_height: 10
#                 description_offset: 1
#                 # If true, the cursor pos will be corrected, so the suggestions match up with the typed text
#                 #
#                 # C:\> str
#                 #      str join
#                 #      str trim
#                 #      str split
#                 correct_cursor_pos: false
#             }
#             style: {
#                 text: green
#                 selected_text: { attr: r }
#                 description_text: yellow
#                 match_text: { attr: u }
#                 selected_match_text: { attr: ur }
#             }
#         }
#         {
#             name: history_menu
#             only_buffer_difference: true
#             marker: "? "
#             type: {
#                 layout: list
#                 page_size: 10
#             }
#             style: {
#                 text: green
#                 selected_text: green_reverse
#                 description_text: yellow
#             }
#         }
#         {
#             name: help_menu
#             only_buffer_difference: true
#             marker: "? "
#             type: {
#                 layout: description
#                 columns: 4
#                 col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
#                 col_padding: 2
#                 selection_rows: 4
#                 description_rows: 10
#             }
#             style: {
#                 text: green
#                 selected_text: green_reverse
#                 description_text: yellow
#             }
#         }
#     ]
#
#     keybindings: [
#         {
#             name: completion_next_menu
#             modifier: none
#             keycode: tab
#             mode: [emacs vi_normal vi_insert]
#             event: {
#                 until: [
#                     { send: menu name: completion_menu }
#                     { send: menunext }
#                     { edit: complete }
#                 ]
#             }
#         }
#     {
#         name: completion_previous_menu
#         modifier: shift
#         keycode: backtab
#         mode: [emacs, vi_normal, vi_insert]
#         event: { send: menuprevious }
#     }
#         {
#             name: ide_completion_menu
#             modifier: control
#             keycode: char_n
#             mode: [emacs vi_normal vi_insert]
#             event: {
#                 until: [
#                     { send: menu name: ide_completion_menu }
#                     { send: menunext }
#                     { edit: complete }
#                 ]
#             }
#         }
#     # {
#     #     name: history_menu
#     #     modifier: control
#     #     keycode: char_r
#     #     mode: [emacs, vi_insert, vi_normal]
#     #     event: { send: menu name: history_menu }
#     # }
#     {
#         name: help_menu
#         modifier: none
#         keycode: f1
#         mode: [emacs, vi_insert, vi_normal]
#         event: { send: menu name: help_menu }
#     }
#     {
#         name: next_page_menu
#         modifier: control
#         keycode: char_x
#         mode: emacs
#         event: { send: menupagenext }
#     }
#     {
#         name: undo_or_previous_page_menu
#         modifier: control
#         keycode: char_z
#         mode: emacs
#         event: {
#             until: [
#                 { send: menupageprevious }
#                 { edit: undo }
#             ]
#         }
#     }
#     {
#         name: escape
#         modifier: none
#         keycode: escape
#         mode: [emacs, vi_normal, vi_insert]
#         event: { send: esc }    # NOTE: does not appear to work
#     }
#     {
#         name: cancel_command
#         modifier: control
#         keycode: char_c
#         mode: [emacs, vi_normal, vi_insert]
#         event: { send: ctrlc }
#     }
#     {
#         name: quit_shell
#         modifier: control
#         keycode: char_d
#         mode: [emacs, vi_normal, vi_insert]
#         event: { send: ctrld }
#     }
#     {
#         name: clear_screen
#         modifier: control
#         keycode: char_l
#         mode: [emacs, vi_normal, vi_insert]
#         event: { send: clearscreen }
#     }
#     {
#         name: search_history
#         modifier: control
#         keycode: char_q
#         mode: [emacs, vi_normal, vi_insert]
#         event: { send: searchhistory }
#     }
#     {
#         name: open_command_editor
#         modifier: control
#         keycode: char_o
#         mode: [emacs, vi_normal, vi_insert]
#         event: { send: openeditor }
#     }
#     {
#         name: move_up
#         modifier: none
#         keycode: up
#         mode: [emacs, vi_normal, vi_insert]
#         event: {
#             until: [
#                     { send: menuup }
#                     { send: up }
#             ]
#         }
#     }
#     {
#         name: move_down
#         modifier: none
#         keycode: down
#         mode: [emacs, vi_normal, vi_insert]
#         event: {
#             until: [
#                     { send: menudown }
#                     { send: down }
#             ]
#         }
#     }
#     {
#         name: move_left
#         modifier: none
#         keycode: left
#         mode: [emacs, vi_normal, vi_insert]
#         event: {
#             until: [
#                     { send: menuleft }
#                     { send: left }
#             ]
#         }
#     }
#     {
#         name: move_right_or_take_history_hint
#         modifier: none
#         keycode: right
#         mode: [emacs, vi_normal, vi_insert]
#         event: {
#             until: [
#                     { send: historyhintcomplete }
#                     { send: menuright }
#                     { send: right }
#             ]
#         }
#     }
#     {
#         name: move_one_word_left
#         modifier: control
#         keycode: left
#         mode: [emacs, vi_normal, vi_insert]
#             event: { edit: movewordleft }
#     }
#     {
#         name: move_one_word_right_or_take_history_hint
#         modifier: control
#         keycode: right
#         mode: [emacs, vi_normal, vi_insert]
#         event: {
#             until: [
#                     { send: historyhintwordcomplete }
#                     { edit: movewordright }
#             ]
#         }
#     }
#     {
#         name: move_to_line_start
#         modifier: none
#         keycode: home
#         mode: [emacs, vi_normal, vi_insert]
#             event: { edit: movetolinestart }
#     }
#     # {
#     #     name: move_to_line_start
#     #     modifier: control
#     #     keycode: char_a
#     #     mode: [emacs, vi_normal, vi_insert]
#     #     event: {edit: movetolinestart}
#     # }
#     {
#         name: move_to_line_end_or_take_history_hint
#         modifier: none
#         keycode: end
#         mode: [emacs, vi_normal, vi_insert]
#         event: {
#             until: [
#                     { send: historyhintcomplete }
#                     { edit: movetolineend }
#             ]
#         }
#     }
#     {
#         name: move_to_line_end_or_take_history_hint
#         modifier: control
#         keycode: char_e
#         mode: [emacs, vi_normal, vi_insert]
#         event: {
#             until: [
#                 { send: historyhintcomplete }
#                 # {edit: movetolineend}
#                 { edit: movetoend }
#             ]
#         }
#     }
#     {
#         name: move_to_line_start
#         modifier: control
#         keycode: home
#         mode: [emacs, vi_normal, vi_insert]
#             event: { edit: movetolinestart }
#     }
#     {
#         name: move_to_line_end
#         modifier: control
#         keycode: end
#         mode: [emacs, vi_normal, vi_insert]
#             event: { edit: movetolineend }
#     }
#     # {
#     #     name: move_down
#     #     modifier: control
#     #     keycode: char_n
#     #     mode: [emacs, vi_normal, vi_insert]
#     #     event: {
#     #         until: [
#     #                 { send: menudown }
#     #                 { send: down }
#     #         ]
#     #     }
#     # }
#     {
#         name: move_up
#         modifier: control
#         keycode: char_p
#         mode: [emacs, vi_normal, vi_insert]
#         event: {
#             until: [
#                     { send: menuup }
#                     { send: up }
#             ]
#         }
#     }
#     {
#         name: delete_one_character_backward
#         modifier: none
#         keycode: backspace
#         mode: [emacs, vi_insert]
#             event: { edit: backspace }
#     }
#     {
#         name: delete_one_word_backward
#         modifier: control
#         keycode: backspace
#         mode: [emacs, vi_insert]
#             event: { edit: backspaceword }
#     }
#     {
#         name: delete_one_character_forward
#         modifier: none
#         keycode: delete
#         mode: [emacs, vi_insert]
#             event: { edit: delete }
#     }
#     {
#         name: delete_one_character_forward
#         modifier: control
#         keycode: delete
#         mode: [emacs, vi_insert]
#             event: { edit: delete }
#     }
#     {
#             name: delete_one_character_backward
#         modifier: control
#         keycode: char_h
#         mode: [emacs, vi_insert]
#             event: { edit: backspace }
#     }
#     # {
#     #     name: delete_one_word_backward
#     #     modifier: control
#     #     keycode: char_w
#     #     mode: [emacs, vi_insert]
#     #         event: { edit: backspaceword }
#     # }
#     {
#         name: move_left
#         modifier: none
#         keycode: backspace
#         mode: vi_normal
#             event: { edit: moveleft }
#     }
#     {
#         name: newline_or_run_command
#         modifier: none
#         keycode: enter
#         mode: emacs
#             event: { send: enter }
#     }
#     {
#         name: move_left
#         modifier: control
#         keycode: char_b
#         mode: emacs
#         event: {
#             until: [
#                     { send: menuleft }
#                     { send: left }
#             ]
#         }
#     }
#     # {
#     #     name: move_right_or_take_history_hint
#     #     modifier: control
#     #     keycode: char_f
#     #     mode: emacs
#     #     event: {
#     #         until: [
#     #                 { send: historyhintcomplete }
#     #                 { send: menuright }
#     #                 { send: right }
#     #         ]
#     #     }
#     # }
#     {
#         name: redo_change
#         modifier: control
#         keycode: char_g
#         mode: emacs
#             event: { edit: redo }
#     }
#     {
#         name: undo_change
#         modifier: control
#         keycode: char_z
#         mode: emacs
#             event: { edit: undo }
#     }
#     {
#         name: paste_before
#         modifier: control
#         keycode: char_y
#         mode: emacs
#             event: { edit: pastecutbufferbefore }
#     }
#     {
#         name: cut_word_left
#         modifier: control
#         keycode: char_w
#         mode: emacs
#             event: { edit: cutwordleft }
#     }
#     {
#         name: cut_line_to_end
#         modifier: control
#         keycode: char_k
#         mode: emacs
#             event: { edit: cuttoend }
#     }
#     {
#         name: cut_line_from_start
#         modifier: control
#         keycode: char_u
#         mode: emacs
#             event: { edit: cutfromstart }
#     }
#     {
#         name: swap_graphemes
#         modifier: control_alt
#         keycode: char_t
#         mode: emacs
#             event: { edit: swapgraphemes }
#     }
#     {
#         name: move_one_word_left
#         modifier: alt
#         keycode: left
#         mode: emacs
#             event: { edit: movewordleft }
#     }
#     {
#         name: move_one_word_right_or_take_history_hint
#         modifier: alt
#         keycode: right
#         mode: emacs
#         event: {
#             until: [
#                     { send: historyhintwordcomplete }
#                     { edit: movewordright }
#             ]
#         }
#     }
#     {
#         name: move_one_word_left
#         modifier: alt
#         keycode: char_b
#         mode: emacs
#             event: { edit: movewordleft }
#     }
#     # {
#     #     name: move_one_word_right_or_take_history_hint
#     #     modifier: alt
#     #     keycode: char_f
#     #     mode: emacs
#     #     event: {
#     #         until: [
#     #                 { send: historyhintwordcomplete }
#     #                 { edit: movewordright }
#     #         ]
#     #     }
#     # }
#     {
#         name: delete_one_word_forward
#         modifier: alt
#         keycode: delete
#         mode: emacs
#             event: { edit: deleteword }
#     }
#     {
#         name: delete_one_word_backward
#         modifier: alt
#         keycode: backspace
#         mode: emacs
#             event: { edit: backspaceword }
#     }
#     {
#         name: delete_one_word_backward
#         modifier: alt
#         keycode: char_m
#         mode: emacs
#             event: { edit: backspaceword }
#     }
#     {
#         name: cut_word_to_right
#         modifier: alt
#         keycode: char_d
#         mode: emacs
#             event: { edit: cutwordright }
#     }
#     {
#         name: upper_case_word
#         modifier: alt
#         keycode: char_u
#         mode: emacs
#             event: { edit: uppercaseword }
#     }
#     {
#         name: lower_case_word
#         modifier: alt
#         keycode: char_l
#         mode: emacs
#             event: { edit: lowercaseword }
#     }
#     {
#         name: capitalize_char
#         modifier: alt
#         keycode: char_c
#         mode: emacs
#             event: { edit: capitalizechar }
#     }
#         # The following bindings with `*system` events require that Nushell has
#         # been compiled with the `system-clipboard` feature.
#         # If you want to use the system clipboard for visual selection or to
#         # paste directly, uncomment the respective lines and replace the version
#         # using the internal clipboard.
#     {
#         name: copy_selection
#         modifier: control_shift
#         keycode: char_c
#         mode: emacs
#         event: { edit: copyselection }
#             # event: { edit: copyselectionsystem }
#     }
#     {
#         name: cut_selection
#         modifier: control_shift
#         keycode: char_x
#         mode: emacs
#         event: { edit: cutselection }
#             # event: { edit: cutselectionsystem }
#     }
#         # {
#         #     name: paste_system
#         #     modifier: control_shift
#         #     keycode: char_v
#         #     mode: emacs
#         #     event: { edit: pastesystem }
#         # }
#     {
#         name: select_all
#         modifier: control_shift
#         keycode: char_a
#         mode: emacs
#         event: { edit: selectall }
#     }
#     ]
# }
#
#
#
# $env.config.menus ++= [
#         {
#             # List all unique successful commands
#             name: all_history_menu
#             only_buffer_difference: true
#             marker: "? "
#             type: {
#                 layout: list
#                 page_size: 10
#             }
#             style: {
#                 text: green
#                 selected_text: green_reverse
#             }
#             source: {|buffer, position|
#                 history
#                 | select command exit_status
#                 | where exit_status != 1
#                 | where command =~ $buffer
#                 | each {|it| {value: $it.command } }
#                 | reverse
#                 | uniq
#             }
#         }
# ]
#
#
#
#
# $env.config.keybindings ++= [
#     {
#         name: move_to__start
#         modifier: control
#         keycode: char_a
#         mode: [emacs, vi_normal, vi_insert]
#         event: {edit: movetostart}
#     }
#     {
#         name: insert_newline
#         modifier: alt
#         keycode: enter
#         mode: [emacs vi_normal vi_insert]
#             event: { edit: insertnewline }
#     }
#     {
#         name: paste
#         modifier: control_shift
#         keycode: char_v
#         mode: emacs
#         event: { edit: pastecutbufferbefore }
#     }
# ]
#
# # $env.config.menus ++= [
# #     { # favorites
# #         name: commands_menu
# #         only_buffer_difference: false
# #         marker: "# "
# #         type: {
# #             layout: columnar
# #             columns: 4
# #             col_width: 20
# #             col_padding: 2
# #         }
# #         style: {
# #             text: green
# #             selected_text: green_reverse
# #             description_text: yellow
# #         }
# #         source: {|buffer, position|
# #             scope commands
# #             | filter {|it| $it.name =~ $buffer }
# #             | each {|it| {value: $it.name } }
# #         }
# #     }
# # ]
# # $env.config.keybindings ++= [
# #     # Keybindings used to trigger the user defined menus
# #     {
# #         name: commands_menu
# #         modifier: control
# #         keycode: char_t
# #         mode: [emacs, vi_normal, vi_insert]
# #         event: { send: menu name: commands_menu }
# #     }
# # ]
#
# $env.config.menus ++= [
#     {
#         name: vars_menu
#         only_buffer_difference: true
#         marker: "# "
#         type: {
#             layout: list
#             page_size: 10
#         }
#         style: {
#             text: green
#             selected_text: green_reverse
#             description_text: yellow
#         }
#         source: {|buffer, position|
#             scope variables
#             | where name not-in ($env.ignore-env-vars? | default [])
#             | sort-by var_id -r
#             | where name =~ $buffer
#             | each {|it| {value: $it.name description: $it.type} }
#         }
#     }
# ]
# $env.config.keybindings ++= [
#     {
#         name: vars_menu
#         modifier: alt
#         keycode: char_o
#         mode: [emacs, vi_normal, vi_insert]
#         event: { send: menu name: vars_menu }
#     }
# ]
#
#
# # $env.config.menus ++= [
# #         {
# #             name: commands_with_description
# #             only_buffer_difference: true
# #             marker: "# "
# #             type: {
# #                 layout: description
# #                 columns: 4
# #                 col_width: 20
# #                 col_padding: 2
# #                 selection_rows: 4
# #                 description_rows: 10
# #             }
# #             style: {
# #                 text: green
# #                 selected_text: green_reverse
# #                 description_text: yellow
# #             }
# #             source: {|buffer, position|
# #                 scope commands
# #                 | where name =~ $buffer
# #                 | each {|it| {value: $it.name description: $it.usage} }
# #             }
# #         }
# # ]
# # $env.config.keybindings ++= [
# #     {
# #         name: commands_with_description
# #         modifier: control
# #         keycode: char_s
# #         mode: [emacs, vi_normal, vi_insert]
# #         event: { send: menu name: commands_with_description }
# #     }
# # ]
#
# ####
#
# $env.config.menus ++= [
#     {
#         # List all unique successful commands in the current directory
#         name: pwd_history_menu
#         only_buffer_difference: true
#         marker: "? "
#         type: {
#             layout: list
#             page_size: 25
#         }
#         style: {
#             text: green
#             selected_text: green_reverse
#         }
#         source: {|buffer, position|
#             history
#             | select command exit_status cwd
#             | where exit_status != 1
#             | where cwd == $env.PWD
#             | where command =~ $buffer
#             | each {|it| {value: $it.command } }
#             | reverse
#             | uniq
#         }
#     }
# ]
# $env.config.keybindings ++= [
#     {
#         name: "pwd history"
#         modifier: control
#         keycode: char_h
#         mode: emacs
#         event: { send: menu name: pwd_history_menu }
#     }
# ]
#
# ####
#
# $env.config.menus ++= [
#     {
#         # session menu
#         name: current_session_menu
#         only_buffer_difference: false
#         marker: "# "
#         type: {
#             layout: list
#             page_size: 10
#         }
#         style: {
#             text: green
#             selected_text: green_reverse
#             description_text: yellow
#         }
#         source: {|buffer, position|
#             history -l
#             | where session_id == (history session)
#             | select command
#             | where command =~ $buffer
#             | each {|it| {value: $it.command } }
#             | reverse
#             | uniq
#         }
#     }
# ]
#
# $env.config.keybindings ++= [
#     {
#         name: "current_session_menu"
#         modifier: alt
#         keycode: char_r
#         mode: emacs
#         event: { send: menu name: current_session_menu }
#     }
# ]
#
# ####
#
# $env.config.menus ++= [
#     {
#         # session menu
#         name: pipe_completions_menu
#         only_buffer_difference: false # Search is done on the text written after activating the menu
#         marker: "# "
#         type: {
#             layout: list
#             page_size: 25
#         }
#         style: {
#             text: green
#             selected_text: green_reverse
#             description_text: yellow
#         }
#         source: {|buffer, position|
#
#             let esc_regex: closure = {|i|
#                 let $input = $i
#                 let $regex_special_symbols = [\\, \., \^, "\\$", \*, \+, \?, "\\{", "\\}", "\\(", "\\)", "\\[", "\\]", "\\|", \/]
#
#                 $regex_special_symbols
#                 | str replace '\' ''
#                 | zip $regex_special_symbols
#                 | reduce -f $input {|i acc| $acc | str replace -a $i.0 $i.1}
#             }
#
#             let $segments = $buffer | split row -r '(\s\|\s)|\(|;|(\{\|\w\| )'
#             let $last_segment = $segments | last
#             let $last_segment_esc = do $esc_regex $last_segment
#             let $smt = $buffer | str replace -r $'($last_segment_esc)$' ' '
#
#             history
#             | get command
#             | uniq
#             | where $it =~ $last_segment_esc
#             | each {
#                 str replace -a (char nl) ' '
#                 | str replace -r $'.*($last_segment_esc)' $last_segment
#                 | $"($smt)($in)"
#             }
#             | reverse
#             | uniq
#             | each {|it| {value: $it}}
#         }
#     }
# ]
# $env.config.keybindings ++= [
#     {
#         name: "pipe_completions_menu"
#         modifier: shift_alt
#         keycode: char_s
#         mode: emacs
#         event: { send: menu name: pipe_completions_menu }
#     }
# ]
#
# ####
#
# $env.config.menus ++= [
#     {
#         # List all unique successful commands
#         name: working_dirs_cd_menu
#         only_buffer_difference: true
#         marker: "? "
#         type: {
#             layout: list
#             page_size: 23
#         }
#         style: {
#             text: green
#             selected_text: green_reverse
#         }
#         source: {|buffer, position|
#             open $nu.history-path
#             | query db "SELECT DISTINCT(cwd) FROM history ORDER BY id DESC"
#             | get CWD
#             | where $it =~ $buffer
#             | each {|it| {value: $it}}
#         }
#     }
# ]
# $env.config.keybindings ++= [
#     {
#         name: "working_dirs_cd_menu"
#         modifier: alt_shift
#         keycode: char_r
#         mode: emacs
#         event: { send: menu name: working_dirs_cd_menu}
#     }
# ]
#
# ####
#
# def prompt_to_raw_source [] {
#     let $closure = {
#         let input = commandline;
#         let hashes = $input | parse -r '(#+)' | get capture0 | sort -r | get 0? | default '';
#         $" r#($hashes)'($input)'#($hashes) | prompt " | commandline edit -r $in
#     }
#
#     view source $closure | lines | skip | drop | to text
# }
# $env.config.keybindings ++= [
#     {
#         name: prompt_to_raw_string
#         modifier: control
#         keycode: char_v
#         mode: [emacs , vi_normal, vi_insert]
#         event: {
#             send: executehostcommand
#             cmd: (prompt_to_raw_source)
#         }
#     }
# ]
#
# ####
#
# $env.config.keybindings ++= [
#     {
#         name: fzf_history_entries
#         modifier: control
#         keycode: char_f
#         mode: [emacs , vi_normal, vi_insert]
#         event: {
#             send: executehostcommand
#             cmd: (fzf-hist-all-reverse-append)
#         }
#     }
#     {
#         name: fzf_history
#         modifier: alt
#         keycode: char_f
#         mode: [emacs , vi_normal, vi_insert]
#         event: {
#             send: executehostcommand
#             cmd: (fzf-hist-current-commandline-prefix-replace)
#         }
#     }
#     {
#         name: fzf_history_sessions
#         modifier: alt_control
#         keycode: char_f
#         mode: [emacs , vi_normal, vi_insert]
#         event: {
#             send: executehostcommand
#             cmd: (fzf-hist-with-sessions-that-include-current-entry)
#         }
#     }
# ]
#
# # F1 is much better than this
# #
# # def help_source [] {
# #     let $closure = {
# #         help commands
# #         | get name
# #         | str join "\n"
# #         | fzf +s --preview-window 'right,85%,border-bottom,+{2}+3/3,~1' --preview $"
# #             nu --config '($nu.config-path)' --env-config '($nu.env-path)' -c \"help {..}\"
# #         "
# #     }
#
# #     view source $closure | lines | skip | drop | to text
# # }
# # $env.config.keybindings ++= [
# #     {
# #         name: help_fzf
# #         modifier: alt
# #         keycode: char_1
# #         mode: [emacs , vi_normal, vi_insert]
# #         event: {
# #             send: executehostcommand
# #             cmd: (help_source)
# #         }
# #     }
# # ]
#
# $env.config.keybindings ++= [
#     {
#         name: copy_command
#         modifier: control_alt
#         keycode: char_c
#         mode: [emacs, vi_normal, vi_insert]
#         event: {
#             send: executehostcommand
#             cmd: "commandline | pbcopy; commandline edit --append ' # copied'"
#         }
#     }
# ]
#
# # return an element from the given position of a command line
# def return-cline-element [
#     $cl: string
#     $pos: int
# ] {
#     ast --flatten $cl
#     | flatten
#     | where start <= $pos and end >= $pos
#     | get content.0 -i
#     | default ''
# }
# def broot-source [] {
#     let $broot_closure = {
#         let $cl = commandline
#         let $pos = commandline get-cursor
#
#         let $element = return-cline-element $cl $pos
#
#         let $path_exp = $element
#             | str trim -c '"'
#             | str trim -c "'"
#             | str trim -c '`'
#             | if $in =~ '^~' { path expand } else {}
#             | if ($in | path exists) {} else {'.'}
#
#         let $broot_path = ^broot $path_exp --conf ($env.XDG_CONFIG_HOME | path join broot select.hjson)
#             | if ' ' in $in { $"`($in)`" } else {}
#
#         if $path_exp == '.' {
#             commandline edit --insert $broot_path
#         } else {
#             $cl | str replace $element $broot_path | commandline edit -r $in
#         }
#     }
#
#     view source $broot_closure | lines | skip | drop | to text
# }
# $env.config.keybindings ++= [
#     {
#          name: broot_path_completion
#          modifier: control
#          keycode: char_t
#          mode: [emacs, vi_normal, vi_insert]
#          event: [
#             {
#                 send: ExecuteHostCommand
#                 cmd: (broot-source)
#             }
#         ]
#     }
# ]
#
# # source /Users/user/git/nu_scripts/sourced/shorcuts.nu
# # source /Users/user/git/nu_scripts/sourced/standard_4002.nu
# source /Users/user/git/nu_scripts_upstream/custom-completions/zellij/zellij-completions.nu
# # $env.CARAPACE_BRIDGES = 'zsh'
# source /Users/user/.config/broot/launcher/nushell/br
# source /Users/user/git/nu_scripts/sourced/standard_4002_aliasses.nu
# # source ~/.cache/carapace/init.nu
#
# let closure1 = {|i| history | where command == $i | last | commandline edit -r $in}
#
# # use /Users/user/git/nu_scripts/modules/virtual_environments/conda.nu
#
# # use /Users/user/git/nu_scripts/sourced/gpt.nu
#
# use /Users/user/git/nu-goodies/nu-goodies *
# use /Users/user/git/nushell-kv/kv.nu
# use /Users/user/git/dotnu/dotnu
# use /Users/user/git/numd/numd
# use /Users/user/git/nushell-openai/openai.nu ask
#
# # overlay use /Users/user/git/cosmos-nushell/out/cyber/cyber_nu_completions.nu as cyber
# # overlay hide cyber
# # overlay use /Users/user/git/cosmos-nushell/out/gaiad/gaiad_nu_completions.nu as gaiad
# # overlay hide gaiad
# # overlay use /Users/user/git/cosmos-nushell/out/pussy/pussy_nu_completions.nu as pussy
# # overlay hide pussy
# # overlay use /Users/user/git/cosmos-nushell/out/osmosisd/osmosisd_nu_completions.nu as osmosisd
# # overlay hide osmosisd
#
# # overlay use /Users/user/cy/cy as cy -pr
# # overlay use /Users/user/cy/cy/cy-full.nu as 'cy' -pr
# # alias cr = overlay use -r /Users/user/cy/cy.nu as cy_no_prefix
# # alias cr = overlay use -pr /Users/user/cy/cy as cy
#
# # cr
#
# use /Users/user/git/nu-cmd-stack/cmd-stack
# use /Users/user/git/nushell-prophet-show/npshow
# source /Users/user/git/my_nu_completions/my_nu_completions.nu
# # alias code = ^/usr/local/bin/code
#
# # use /Users/user/git/manuscript/nuout.nu
#
# alias beep = say done
#
# $env.ignore-env-vars = (scope variables | get name)
#
# # use /Users/user/.config/broot/launcher/nushell/br *
# # use /Users/user/git/darkdraw-ansi-ddw-converter/ddw.nu
# # use /Users/user/temp/nushell-formatter *
# def 'str escape-regex' [] {}
#
# def get-longest-hash-sym []: string -> string {parse -r '(#+)' | get capture0 | sort -r | get 0? | default ''}
#
# def make_raw_string []: string -> string {let $input = $in; let $hashes = $input | get-longest-hash-sym; $" r#($hashes)'($input)'#($hashes)"}
#
# # find the '^' prefixed current commandline in whole history; replace current commandline
# def 'fzf-hist-current-commandline-prefix-replace' [] {
#     let closure = {
#         open $nu.history-path
#         | query db '
#             WITH ordered_history AS (
#                 SELECT command_line
#                 FROM history
#                 ORDER BY id DESC
#             )
#             SELECT DISTINCT command_line
#             FROM ordered_history;
#         '
#         | get command_line
#         | each { str replace -a '    ' "\u{200B}" }
#         | str join (char nul)
#         | fzf --cycle --scheme=history --read0 --print0 --tiebreak=begin,length,chunk --layout=reverse --multi --with-shell='sh -c' --preview="echo {..}" --preview-window='bottom:3:wrap' --height=70% --query=$'^(commandline | str replace -a "| " "")' --wrap --header="ctrl-r to disable sort" --header-first
#         | decode utf-8
#         | str trim --char (char nl)
#         | str replace -ar (char nul) $';(char nl)'
#         | str replace -a "\u{200B}" '    '
#         | str trim
#         | commandline edit --replace $in
#         | commandline set-cursor -e
#     }
#
#     view source $closure | lines | skip | drop | to text
# }
#
# def 'fzf-hist-all-reverse-append' [] {
#     let closure = {
#         let $index_sep = "\u{200C}\t"
#         let $entry_sep = "\u{200B}"
#
#         open $nu.history-path
#         | query db '
#             WITH ordered_history AS (
#                 SELECT
#                     id,
#                     command_line,
#                     ROW_NUMBER() OVER (PARTITION BY command_line ORDER BY id DESC) AS row_num
#                 FROM history
#             )
#             SELECT
#                 id,
#                 command_line
#             FROM ordered_history
#             WHERE row_num = 1
#             ORDER BY id DESC;
#         '
#         | each {$"($in.id)($index_sep)($in.command_line)"}
#         | str join (char nul)
#         | ($in | fzf --cycle --read0 --print0
#             --bind='ctrl-r:toggle-sort'
#             --delimiter=$'($index_sep)'
#             --height=70%
#             --layout=reverse
#             --multi
#             --preview-window='bottom:30%:wrap'
#             --preview=" echo {2} | nu -n --no-std-lib --stdin -c 'nu-highlight' "
#             --tiebreak=begin,length,chunk
#             --with-shell='bash -c '
#             --wrap
#             --wrap-sign "\t↳ "
#             -n2..
#         )
#         | decode utf-8
#         | str trim --char (char nl)
#         | str replace -ar $'(char lp)^|(char nul)(char rp)\d+?($index_sep)' '$1'
#         | str replace -ar (char nul) $';(char nl)'
#         | str replace -a $entry_sep '    '
#         | str trim
#         | commandline edit --append $in
#         | commandline set-cursor -e
#     }
#
#     view source $closure | lines | skip | drop | to text
# }
#
# def 'fzf-hist-sessions-source-code' [] {
#     let closure = {
#         open $nu.history-path
#         | query db -p [
#             (commandline | split row $';(char nl)' | to json)
#         ] "
#             WITH json_values AS (
#                 SELECT value
#                 FROM json_each(?)
#             )
#             SELECT *
#             FROM history AS full_history
#             JOIN (
#                 SELECT DISTINCT session_id
#                 FROM history AS session_history
#                 WHERE EXISTS (
#                     SELECT 1
#                     FROM json_values
#                     WHERE session_history.command_line LIKE '%' || json_values.value || '%'
#                 )
#             ) AS matching_sessions
#             ON full_history.session_id = matching_sessions.session_id;
#         "
#         | get command_line
#         | each { str replace -a '    ' "\u{200B}" }
#         | str join (char nul)
#         | fzf --cycle --scheme=history --read0 --print0 --tiebreak=begin,length,chunk --layout=reverse --multi --with-shell='sh -c' --preview="echo {..}" --preview-window='bottom:3:wrap' --height=70%
#         | decode utf-8
#         | str trim --char (char nl)
#         | str replace -ar (char nul) $';(char nl)'
#         | str replace -a "\u{200B}" '    '
#         | str trim
#         | commandline edit -a $in
#         | commandline set-cursor -e
#     }
#
#     view source $closure | lines | skip | drop | to text
# }
#
#
# def 'fzf-hist-with-sessions-that-include-current-entry' [] {
#     let closure = {
#         open $nu.history-path
#         | query db -p [
#             (commandline | split row -r $';(char nl)?' | str trim | compact --empty | to json)
#         ] "
#             WITH json_values AS (
#                 SELECT value
#                 FROM json_each(?)
#             )
#             SELECT DISTINCT command_line
#             FROM history AS session_history
#             WHERE EXISTS (
#                 SELECT 1
#                 FROM json_values
#                 WHERE session_history.command_line LIKE '%' || json_values.value || '%'
#             )
#         "
#         | get command_line
#         | each { str replace -a '    ' "\u{200B}" }
#         | str join (char nul)
#         | fzf --cycle --no-sort --read0 --print0 --tiebreak=begin,length,chunk --layout=reverse --multi --with-shell='sh -c' --preview="echo {..}" --preview-window='bottom:3:wrap' --height=70% --wrap
#         | decode utf-8
#         | str trim --char (char nl)
#         | str replace -ar (char nul) $';(char nl)'
#         | str replace -a "\u{200B}" '    '
#         | str trim
#         | commandline edit -a $in
#         | commandline set-cursor -e
#     }
#
#     view source $closure | lines | skip | drop | to text
# }
#
# def lsg [] { }
#
# # make command to execute fzf menu, to ask what to do with current commandline
