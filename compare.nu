let current = nu --config $nu.config-path --env-config $nu.env-path new-settings.nu | from nuon | rename key current
let defaults = nu -n -c '$env.config = {}; source new-settings.nu' | from nuon | rename key default

let comparison = $defaults | join $current key | where $it.default != $it.current

print $'(ansi yellow)The differences(ansi reset)' $comparison ''

print $'(ansi yellow)Cell paths notation (ansi reset)'
$comparison | each {$'($in.key) = ($in.current)'} | to text
