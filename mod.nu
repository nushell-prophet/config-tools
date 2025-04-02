export def 'config set' [
    setting: any@nu-config-completions
    value?: any
    --commandline # return setting to commandline
] {
    let current_value = $env.config | get (
        $setting | split row '.' | into cell-path
    )

    let value = if $value == null {
        $current_value
        | if ($in | describe) == bool { not $in } else { }
    } else { $value }
    | to nuon

    commandline edit -r $'$env.config.($setting) = ($value)'
}

def nu-config-completions [] {
    config flatten
    | transpose
    | rename value description
    | where value !~ '^keybindings'
    | where value !~ '^menus'
    | where value !~ '^color_config'
}
