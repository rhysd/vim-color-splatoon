scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

hi clear
syntax reset
set bg=dark
let g:colors_name = "splatoon"
call splatoon_color#colorize('regular')

let &cpo = s:save_cpo
unlet s:save_cpo
