$env.config.history.file_format = "Sqlite"
$env.config.history.isolation = true
$env.config.history.max_size = 5000000

$env.config.use_kitty_protocol = true

$env.config.table.header_on_separator = true
$env.config.table.show_empty = false
$env.config.footer_mode = "Always"

$env.config.highlight_resolved_externals = true
$env.config.render_right_prompt_on_last_line = true
$env.config.show_banner = false

$env.config.completions.algorithm = "Fuzzy"
$env.config.completions.partial = false
$env.config.completions.quick = false
$env.config.completions.use_ls_colors = false

$env.config.cursor_shape.emacs = "Line"
$env.config.cursor_shape.vi_insert = "Block"
$env.config.cursor_shape.vi_normal = "Underscore"

$env.config.completions.external.completer = {|spans|
    # if the current command is an alias, get it's expansion
    let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)

    # overwrite
    let spans = (
        if $expanded_alias != null  {
        # put the first word of the expanded alias first in the span
            $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
        } else {
            $spans
        }
    )

    carapace $spans.0 nushell ...$spans
    | from json
}

$env.config.hooks = {
        pre_prompt: [{ null }] # run before the prompt is shown
        pre_execution: [{ null }] # run before the repl input is run
        env_change: {

      PWD: [
      { |before, after|
        #print $"before: [($before)], after: [($after)]"
        # print ($env.LS_COLORS)
        print (ls | sort-by type name -i | grid -c -i )
        # null
      },
      {
        condition: {|_, after| not ($after | path join 'toolkit.nu' | path exists)}
        code: "hide toolkit"
        # code: "overlay hide --keep-env [ PWD ] toolkit"
      },
      {
        condition: {|_, after| $after | path join 'toolkit.nu' | path exists}
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

        }
        display_output: {
            metadata access {|meta| match $meta.content_type? {
            "application/x-nuscript" | "application/x-nuon" | "text/x-nushell" => { nu-highlight },
            "application/json" => { ^bat --language=json --color=always --style=plain --paging=never },
            _ => {},
            }
        }
        | if (term size).columns >= 100 { table -e } else { table }
    }

        # run to display the output of a pipeline
        command_not_found: { null } # return an error message when a command is not found
    }

$env.config.keybindings ++= [
        {
            name: ide_completion_menu
            modifier: control
#            keycode: space
            keycode: char_n
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: ide_completion_menu }
                    { send: menunext }
                    { edit: complete }
                ]
            }
        }
    {
        name: move_to_line_end_or_take_history_hint
        modifier: control
        keycode: char_e
        mode: [emacs, vi_normal, vi_insert]
        event: {
            until: [
                { send: historyhintcomplete }
                # {edit: movetolineend}
                { edit: movetoend }
            ]
        }
    }
    {
        name: cut_line_to_end
        modifier: control
        keycode: char_k
        mode: emacs
#            event: { edit: cuttolineend }
            event: { edit: cuttoend }
    }
    {
        name: swap_graphemes
#        modifier: control
        modifier: control_alt
        keycode: char_t
        mode: emacs
            event: { edit: swapgraphemes }
    }
        # The following bindings with `*system` events require that Nushell has
        # been compiled with the `system-clipboard` feature.
        # If you want to use the system clipboard for visual selection or to
        # paste directly, uncomment the respective lines and replace the version
        # using the internal clipboard.
    {
        name: copy_selection
        modifier: control_shift
        keycode: char_c
        mode: emacs
        event: { edit: copyselection }
            # event: { edit: copyselectionsystem }
    }
    {
        name: cut_selection
        modifier: control_shift
        keycode: char_x
        mode: emacs
        event: { edit: cutselection }
            # event: { edit: cutselectionsystem }
    }
    {
        name: select_all
        modifier: control_shift
        keycode: char_a
        mode: emacs
        event: { edit: selectall }
    }
]




$env.config.menus ++= [
        {
            # List all unique successful commands
            name: all_history_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: green
                selected_text: green_reverse
            }
            source: {|buffer, position|
                history
                | select command exit_status
                | where exit_status != 1
                | where command =~ $buffer
                | each {|it| {value: $it.command } }
                | reverse
                | uniq
            }
        }
]




$env.config.keybindings ++= [
    {
        name: move_to__start
        modifier: control
        keycode: char_a
        mode: [emacs, vi_normal, vi_insert]
        event: {edit: movetostart}
    }
    {
        name: insert_newline
        modifier: alt
        keycode: enter
        mode: [emacs vi_normal vi_insert]
            event: { edit: insertnewline }
    }
    {
        name: paste
        modifier: control_shift
        keycode: char_v
        mode: emacs
        event: { edit: pastecutbufferbefore }
    }
]

$env.config.menus ++= [
    {
        name: vars_menu
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: {|buffer, position|
            scope variables
            | where name not-in ($env.ignore-env-vars? | default [])
            | sort-by var_id -r
            | where name =~ $buffer
            | each {|it| {value: $it.name description: $it.type} }
        }
    }
]
$env.config.keybindings ++= [
    {
        name: vars_menu
        modifier: alt
        keycode: char_o
        mode: [emacs, vi_normal, vi_insert]
        event: { send: menu name: vars_menu }
    }
]

####

$env.config.menus ++= [
    {
        # List all unique successful commands in the current directory
        name: pwd_history_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 25
        }
        style: {
            text: green
            selected_text: green_reverse
        }
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
    }
]
$env.config.keybindings ++= [
    {
        name: "pwd history"
        modifier: control
        keycode: char_h
        mode: emacs
        event: { send: menu name: pwd_history_menu }
    }
]

####

$env.config.menus ++= [
    {
        # session menu
        name: current_session_menu
        only_buffer_difference: false
        marker: "# "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: {|buffer, position|
            history -l
            | where session_id == (history session)
            | select command
            | where command =~ $buffer
            | each {|it| {value: $it.command } }
            | reverse
            | uniq
        }
    }
]

$env.config.keybindings ++= [
    {
        name: "current_session_menu"
        modifier: alt
        keycode: char_r
        mode: emacs
        event: { send: menu name: current_session_menu }
    }
]

####

$env.config.menus ++= [
    {
        # session menu
        name: pipe_completions_menu
        only_buffer_difference: false # Search is done on the text written after activating the menu
        marker: "# "
        type: {
            layout: list
            page_size: 25
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: {|buffer, position|

            let esc_regex: closure = {|i|
                let $input = $i
                let $regex_special_symbols = [
                    '\\', '\.', '\^', '\$',
                    '\*', '\+', '\?',
                    '\{', '\}', '\(', '\)',
                    '\[', '\]', '\|', '\/'
                ]

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
    }
]
$env.config.keybindings ++= [
    {
        name: "pipe_completions_menu"
        modifier: shift_alt
        keycode: char_s
        mode: emacs
        event: { send: menu name: pipe_completions_menu }
    }
]

####

$env.config.menus ++= [
    {
        # List all unique successful commands
        name: working_dirs_cd_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 23
        }
        style: {
            text: green
            selected_text: green_reverse
        }
        source: {|buffer, position|
            open $nu.history-path
            | query db "SELECT DISTINCT(cwd) FROM history ORDER BY id DESC"
            | get CWD
            | where $it =~ $buffer
            | each {|it| {value: $it}}
        }
    }
]
$env.config.keybindings ++= [
    {
        name: "working_dirs_cd_menu"
        modifier: alt_shift
        keycode: char_r
        mode: emacs
        event: { send: menu name: working_dirs_cd_menu}
    }
]

####

def prompt_to_raw_source [] {
    let $closure = {
        let input = commandline;
        let hashes = $input | parse -r '(#+)' | get capture0 | sort -r | get 0? | default '';
        $" r#($hashes)'($input)'#($hashes)" | commandline edit -r $in
    }

    view source $closure | lines | skip | drop | to text
}
$env.config.keybindings ++= [
    {
        name: prompt_to_raw_string
        modifier: control
        keycode: char_v
        mode: [emacs , vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: (prompt_to_raw_source)
        }
    }
]

####

# make command to execute fzf menu, to ask what to do with current commandline

def 'fzf-hist-all-reverse-append' [] {
    let closure = {
        let $index_sep = "\u{200C}\t"
        let $entry_sep = "\u{200B}"

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
        | each {$"($in.id)($index_sep)($in.command_line)"}
        | str join (char nul)
        | ($in | fzf --cycle --read0 --print0
            --bind='ctrl-r:toggle-sort'
            --delimiter=$'($index_sep)'
            --height=70%
            --layout=reverse
            --multi
            --preview-window='bottom:30%:wrap'
            --preview=" echo {2} | nu -n --no-std-lib --stdin -c 'nu-highlight' "
            --tiebreak=begin,length,chunk
            --with-shell='bash -c '
            --wrap
            --wrap-sign "\t↳ "
            -n2..
        )
        | decode utf-8
        | str trim --char (char nl)
        | str replace -ar $'(char lp)^|(char nul)(char rp)\d+?($index_sep)' '$1'
        | str replace -ar (char nul) $';(char nl)'
        | str replace -a $entry_sep '    '
        | str trim
        | commandline edit --append $in
        | commandline set-cursor -e
    }

    view source $closure | lines | skip | drop | to text
}
$env.config.keybindings ++= [
    {
        name: fzf_history_entries
        modifier: control
        keycode: char_f
        mode: [emacs , vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: (fzf-hist-all-reverse-append)
        }
    }
]

# find the '^' prefixed current commandline in whole history; replace current commandline
def 'fzf-hist-current-commandline-prefix-replace' [] {
    let closure = {
        open $nu.history-path
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
        | each { str replace -a '    ' "\u{200B}" }
        | str join (char nul)
        | fzf --cycle --scheme=history --read0 --print0 --tiebreak=begin,length,chunk --layout=reverse --multi --with-shell='sh -c' --preview="echo {..}" --preview-window='bottom:3:wrap' --height=70% --query=$'^(commandline | str replace -a "| " "")' --wrap --header="ctrl-r to disable sort" --header-first
        | decode utf-8
        | str trim --char (char nl)
        | str replace -ar (char nul) $';(char nl)'
        | str replace -a "\u{200B}" '    '
        | str trim
        | commandline edit --replace $in
        | commandline set-cursor -e
    }

    view source $closure | lines | skip | drop | to text
}
$env.config.keybindings ++= [
    {
        name: fzf_history
        modifier: alt
        keycode: char_f
        mode: [emacs , vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: (fzf-hist-current-commandline-prefix-replace)
        }
    }
]

def 'fzf-hist-with-sessions-that-include-current-entry' [] {
    let closure = {
        open $nu.history-path
        | query db -p [
            (commandline | split row -r $';(char nl)?' | str trim | compact --empty | to json)
        ] "
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
        "
        | get command_line
        | each { str replace -a '    ' "\u{200B}" }
        | str join (char nul)
        | fzf --cycle --no-sort --read0 --print0 --tiebreak=begin,length,chunk --layout=reverse --multi --with-shell='sh -c' --preview="echo {..}" --preview-window='bottom:3:wrap' --height=70% --wrap
        | decode utf-8
        | str trim --char (char nl)
        | str replace -ar (char nul) $';(char nl)'
        | str replace -a "\u{200B}" '    '
        | str trim
        | commandline edit -a $in
        | commandline set-cursor -e
    }

    view source $closure | lines | skip | drop | to text
}
$env.config.keybindings ++= [
    {
        name: fzf_history_sessions
        modifier: alt_control
        keycode: char_f
        mode: [emacs , vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: (fzf-hist-with-sessions-that-include-current-entry)
        }
    }
]

$env.config.keybindings ++= [
    {
        name: copy_command
        modifier: control_alt
        keycode: char_c
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "commandline | pbcopy; commandline edit --append ' # copied'"
        }
    }
]

# return an element from the given position of a command line
def return-cline-element [
    $cl: string
    $pos: int
] {
    ast --flatten $cl
    | flatten
    | where start <= $pos and end >= $pos
    | get content.0 -i
    | default ''
}
def broot-source [] {
    let $broot_closure = {
        let $cl = commandline
        let $pos = commandline get-cursor

        let $element = return-cline-element $cl $pos

        let $path_exp = $element
            | str trim -c '"'
            | str trim -c "'"
            | str trim -c '`'
            | if $in =~ '^~' { path expand } else {}
            | if ($in | path exists) {} else {'.'}

        let $broot_path = ^broot $path_exp --conf ($env.XDG_CONFIG_HOME | path join broot select.hjson)
            | if ' ' in $in { $"`($in)`" } else {}

        if $path_exp == '.' {
            commandline edit --insert $broot_path
        } else {
            $cl | str replace $element $broot_path | commandline edit -r $in
        }
    }

    view source $broot_closure | lines | skip | drop | to text
}
$env.config.keybindings ++= [
    {
         name: broot_path_completion
         modifier: control
         keycode: char_t
         mode: [emacs, vi_normal, vi_insert]
         event: [
            {
                send: ExecuteHostCommand
                cmd: (broot-source)
            }
        ]
    }
]

# source /Users/user/git/nu_scripts/sourced/shorcuts.nu
# source /Users/user/git/nu_scripts/sourced/standard_4002.nu
source /Users/user/git/nu_scripts_upstream/custom-completions/zellij/zellij-completions.nu
# $env.CARAPACE_BRIDGES = 'zsh'
source /Users/user/.config/broot/launcher/nushell/br
source /Users/user/git/nu_scripts/sourced/standard_4002_aliasses.nu
source /Users/user/git/my_nu_completions/my_nu_completions.nu

use /Users/user/git/nu-goodies/nu-goodies *
use /Users/user/git/nushell-kv/kv.nu
use /Users/user/git/dotnu/dotnu
use /Users/user/git/numd/numd
use /Users/user/git/nushell-openai/openai.nu ask

use /Users/user/git/nu-cmd-stack/cmd-stack
use /Users/user/git/nushell-prophet-show/npshow

$env.ignore-env-vars = (scope variables | get name)
