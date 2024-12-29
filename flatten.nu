def flatten-keys [rec: any, root: string] {
    match ($rec | describe --detailed | get type) {
        record => {
            $rec
            | columns
            | each {|key|
                let is_record = (
                  $rec | get $key | describe --detailed | get type | $in == record
                )

                # Recusively return either the key or (if a record) its subkeys
                match $is_record {
                    true  => (flatten-keys ($rec | get $key) $'($root).($key)')
                    false => [$'($root).($key)']
                }
            }
            | flatten
        }
        list => {
            seq 0 ($rec | length)
        }
    }
}

try {stor delete --table-name settings-closures}
stor create --table-name settings-closures --columns {uuid: str, closure: str}

export def --env flatten-closures [] {
    let $input = $in

    let $type = $input | describe --detailed | get type

    match $type {
        'list' => {$input | each {flatten-closures}},
        'record' => {
            $input
            | items {|k v| {$k: ($v | flatten-closures)}}
            | into record
        },
        'closure' => {
            let uuid = random uuid

            {uuid: $uuid closure: (view source $input)} | stor insert --table-name settings-closures

            $uuid
        }
        _ => $input
    }
}

stor open | query db 'select * from settings-closures'
