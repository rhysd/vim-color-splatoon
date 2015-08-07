let s:save_cpo = &cpo
set cpo&vim

hi clear
syntax reset
set bg=dark
let g:colors_name = "splatoon-random"
call splatoon_color#colorize('random')

let &cpo = s:save_cpo
unlet s:save_cpo
