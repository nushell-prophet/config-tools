let keybidnings_def = keybindings default | select mode modifier code | where mode == emacs | update modifier {parse -r '\((.*)\)' | get capture0.0 -i | str replace 0x0 'none' | str downcase | split row ' | ' | sort | str join '_'} | update code {str downcase | str replace "('" "_" | str replace "')" ""} | where mode == 'emacs' | group-by code --to-table | update items {select modifier | insert status 'default' | transpose -idr} | flatten

$keybidnings_def | table --width 160 | print $in

#: ╭──#──┬────code────┬───none───┬───alt────┬─...─╮
#: │ 0   │ backspace  │ default  │ default  │ ... │
#: │ 1   │ delete     │ default  │ default  │ ... │
#: │ 2   │ down       │ default  │    ❎    │ ... │
#: │ 3   │ end        │ default  │    ❎    │ ... │
#: │ 4   │ enter      │ default  │ default  │ ... │
#: │ 5   │ esc        │ default  │    ❎    │ ... │
#: │ 6   │ home       │ default  │    ❎    │ ... │
#: │ 7   │ left       │ default  │ default  │ ... │
#: │ 8   │ right      │ default  │ default  │ ... │
#: │ 9   │ up         │ default  │    ❎    │ ... │
#: │ 10  │ char_b     │    ❎    │ default  │ ... │
#: │ 11  │ char_c     │    ❎    │ default  │ ... │
#: │ 12  │ ...        │ ...      │ ...      │ ... │
#: │ 13  │ char_g     │    ❎    │    ❎    │ ... │
#: │ 14  │ char_h     │    ❎    │    ❎    │ ... │
#: │ 15  │ char_j     │    ❎    │    ❎    │ ... │
#: │ 16  │ char_k     │    ❎    │    ❎    │ ... │
#: │ 17  │ char_n     │    ❎    │    ❎    │ ... │
#: │ 18  │ char_o     │    ❎    │    ❎    │ ... │
#: │ 19  │ char_p     │    ❎    │    ❎    │ ... │
#: │ 20  │ char_r     │    ❎    │    ❎    │ ... │
#: │ 21  │ char_t     │    ❎    │    ❎    │ ... │
#: │ 22  │ char_w     │    ❎    │    ❎    │ ... │
#: │ 23  │ char_y     │    ❎    │    ❎    │ ... │
#: │ 24  │ char_z     │    ❎    │    ❎    │ ... │
#: ╰──#──┴────code────┴───none───┴───alt────┴─...─╯
