let keybidnings_def = keybindings default | select mode modifier code | where mode == emacs | update modifier {parse -r '\((.*)\)' | get capture0.0 -i | str replace 0x0 'none' | str downcase | split row ' | ' | sort | str join '_'} | update code {str downcase | str replace "('" "_" | str replace "')" ""} | where mode == 'emacs' | group-by code --to-table | update items {select modifier | insert status 'default' | transpose -idr} | flatten

$keybidnings_def | first 5 | table --width 160 | print $in

#: ╭─#──┬───code────┬──none───┬───alt───┬─control─┬─control_shift─┬──shift──╮
#: │ 0  │ backspace │ default │ default │ default │            ❎ │      ❎ │
#: │ 1  │ delete    │ default │ default │ default │            ❎ │      ❎ │
#: │ 2  │ down      │ default │      ❎ │      ❎ │            ❎ │      ❎ │
#: │ 3  │ end       │ default │      ❎ │ default │ default       │ default │
#: │ 4  │ enter     │ default │ default │      ❎ │            ❎ │ default │
#: │ 5  │ esc       │ default │      ❎ │      ❎ │            ❎ │      ❎ │
#: │ 6  │ home      │ default │      ❎ │ default │ default       │ default │
#: │ 7  │ left      │ default │ default │ default │ default       │ default │
#: │ 8  │ right     │ default │ default │ default │ default       │ default │
#: │ 9  │ up        │ default │      ❎ │      ❎ │            ❎ │      ❎ │
#: │ 10 │ char_b    │      ❎ │ default │ default │            ❎ │      ❎ │
#: │ 11 │ char_c    │      ❎ │ default │ default │            ❎ │      ❎ │
#: │ 12 │ ...       │ ...     │ ...     │ ...     │            ❎ │      ❎ │
#: │ 13 │ char_g    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: │ 14 │ char_h    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: │ 15 │ char_j    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: │ 16 │ char_k    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: │ 17 │ char_n    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: │ 18 │ char_o    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: │ 19 │ char_p    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: │ 20 │ char_r    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: │ 21 │ char_t    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: │ 22 │ char_w    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: │ 23 │ char_y    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: │ 24 │ char_z    │      ❎ │      ❎ │ default │            ❎ │      ❎ │
#: ╰─#──┴───code────┴──none───┴───alt───┴─control─┴─control_shift─┴──shift──╯
