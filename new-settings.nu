# flatten-keys by @NotTheDr01ds
def flatten-keys [rec: record, root: string] {
  $rec | columns | each {|key|
    let is_record = (
      $rec | get $key | describe --detailed | get type | $in == record
    )

    # Recusively return each key plus its subkeys
    [$'($root).($key)'] ++  match $is_record {
      true  => (flatten-keys ($rec | get $key) $'($root).($key)')
      false => []
    }
   } | flatten
}

let $config = $env.config | reject color_config keybindings menus hooks

let $output = flatten-keys $config ''
    | window 2 --remainder
    | each {|i| if ($'($i.1?)' | str contains $i.0) {
          null # parent has childs - don't output it
      } else {$i.0}
    }
    | str replace -r '^\.' ''
    | wrap key
    | insert value {|i|
        $config  | get ($i.key  | split row '.'  | into cell-path) -i
    }

$output | to nuon
