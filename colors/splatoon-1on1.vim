let s:save_cpo = &cpo
set cpo&vim

hi clear
syntax reset
set bg=dark
let g:colors_name = "splatoon-1on1"
call splatoon_color#colorize('1_on_1')

let &cpo = s:save_cpo
unlet s:save_cpo
