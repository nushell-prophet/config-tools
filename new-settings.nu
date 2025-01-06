let $closure = {
    config flatten
    | transpose key value
    | where key !~ '^menu' and key !~ '^keybinding' and key !~ '^hooks'
    | sort-by key
    | update value {
        if ($in | describe) == string and ($in starts-with '{') {
                $"\u{200B}($in)\u{200B}"
        } else {}
    }
    | to nuon
}

let $source_code = view source $closure | lines | skip | drop | to text

let $current = do $closure | ansi strip | from nuon | rename key current
let $defaults = nu -n -c $'$env.config = {}; ($source_code)'
    | from nuon
    | rename key default
    | where key != 'table.trim.wrapping_try_keep_words' # produces error in my testing environment

let $comparison = $defaults | join --outer $current key | where $it.default != $it.current

# $comparison | first 3 | print $in

# print $'(ansi yellow)In your configuration, the following settings appear to be different than the defaults:(ansi reset)(char newline)'
# print ($comparison | table -e)

# print $'(ansi yellow)Your config.nu should include the following:(ansi reset)(char newline)'

let changes = (
    $comparison
    | group-by {|i| $i.default == null | into string}
    | ( $in.false? | default [] ) ++ (
        $in.true?
        | if $in == null {[]} else {
            prepend {key: "###placeholder###" current: ''}
        }
    )
    | each {|i|
        $i.current
        | if ($in | describe) == 'string' and ($in starts-with "\u{200B}") {
            str trim --char "\u{200B}"
        } else {
            to nuon
        }
        | $'$env.config.($i.key) = ($in)'
    }
    | to text
    | str replace -r '(.*)###placeholder###(.*)' "\n# The settings below don't have corresponding default values\n"
    # | nu-highlight
)

# print $changes

# print $"\n\n(ansi yellow)Also compare your keybindings, menus, prompts, and other environment variables.(ansi reset)"

let $current_others = $env.config | select hooks menus keybindings

let $current_others_nu = null
    | append '#hooks'
    | append (
        $current_others.hooks
        | to nuon --serialize --indent 4
        | $"$env.config.hooks = ($in)"
    )
    | append "#menus"
    | append (
        $current_others.menus
        | each {
            to nuon --serialize --indent 4
            | $'$env.config.menus ++= [($in)]'
        }
    )
    | append "#keybidnings"
    | append (
        $current_others.keybindings
        | each {
            to nuon --serialize --indent 4
            | $'$env.config.keybindings ++= [($in)]'
        }
    )
    | str join "\n\n"

let $all_current_configs_commented = open $nu.config-path
    | lines
    | prepend "Your old config is below. Uncomment what is needed, delete redundant.\n"
    | each {$'# ($in)'}

let $new_config = 'config0101.nu'

$changes
| append $current_others_nu
| append $all_current_configs_commented
| to text
| save -f $new_config

commandline edit -r $'# you can try the settings produced by executing this command
($nu.current-exe) --config ($new_config)'
