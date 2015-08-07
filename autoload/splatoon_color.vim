scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:Random = vital#of('splatoon_color').import('Random')

" Preset Colors {{{
" オレンジ
" オレンジ2
" オレンジ（薄い）

" 薄いピンク
" ピンク
" 濃いピンク

" シアン
" 薄いシアン

" 黄色
" 若干濃い黄色

" 青
" 濃い青
" 濃い青2
" 濃い水色

" 黄緑
" 濃い黄緑
" 濃い黄緑（緑寄り）
" 濃い黄緑（黄寄り）
" 緑

" うすい紫
" 紫
" 濃い紫

" 赤

let s:PRESET_COLORS = [
        \   ["#ff8c27", "#ff8c27", "#ff9934"],
        \   ["#fd6495", "#fd2a95", "#fd2a95"],
        \   ["#00ffff", "#26e3dc"],
        \   ["#ffff00", "#fac800"],
        \   ["#3232ff", "#323296", "#3232c8", "#3fa9d9"],
        \   ["#aac800", "#7ac943", "#75d31e", "#c2e329", "#0bd67d"],
        \   ["#961e86", "#ad00bc", "#6400e6"],
        \   ["#c82828"],
        \ ]
" }}}

if !exists('s:rng')
    let s:rng = s:Random.new('Xor128')
endif

" 1 on 1 color generator {{{
function! s:choose_color(arr)
    let i = s:rng.range(len(a:arr))
    let group = a:arr[i]
    let len = len(group)
    if len == 1
        let color = group[0]
    else
        let color = group[s:rng.range(len)]
    endif
    return [color, i]
endfunction

function! splatoon_color#get_1_on_1_generator() abort
    let colors = deepcopy(s:PRESET_COLORS)

    let [first, i] = s:choose_color(colors)
    unlet colors[i]
    let [second, _] = s:choose_color(colors)

    let gen = {"pair" : [first, second]}

    function! gen.gen_fg() dict abort
        return ["guifg=" . self.pair[s:rng.range(2)], ""]
    endfunction

    function! gen.gen_bg() dict abort
        return ["", "guibg=" . self.pair[s:rng.range(2)]]
    endfunction

    function! gen.gen_pair() dict abort
        let n = s:rng.range(2)
        return ["guifg=" . self.pair[n], "guibg=" . self.pair[xor(n, 1)]]
    endfunction

    return gen
endfunction
" }}}

" {{{colorize()
function! s:hi(group, colors, ...) abort
    if a:0 == 1
        execute 'hi' a:group a:colors[0] a:colors[1] "gui=" . a:1
    else
        execute 'hi' a:group a:colors[0] a:colors[1]
    endif
endfunction

function! splatoon_color#colorize(generator_name) abort
    let g = splatoon_color#get_{a:generator_name}_generator()

    call s:hi("Bold"                      , ["", ""], "bold")
    call s:hi("Debug"                     , g.gen_fg())
    call s:hi("Directory"                 , g.gen_fg())
    call s:hi("ErrorMsg"                  , g.gen_pair())
    call s:hi("Exception"                 , g.gen_fg())
    call s:hi("FoldColumn"                , g.gen_fg())
    call s:hi("Folded"                    , g.gen_pair())
    call s:hi("IncSearch"                 , g.gen_pair(), "none")
    call s:hi("Italic"                    , ["", ""], "none")
    call s:hi("Macro"                     , g.gen_fg())
    call s:hi("MatchParen"                , g.gen_pair())
    call s:hi("ModeMsg"                   , g.gen_fg())
    call s:hi("MoreMsg"                   , g.gen_fg())
    call s:hi("Question"                  , g.gen_fg())
    call s:hi("Search"                    , g.gen_pair())
    call s:hi("SpecialKey"                , g.gen_fg())
    call s:hi("TooLong"                   , g.gen_fg())
    call s:hi("Underlined"                , g.gen_fg())
    call s:hi("Visual"                    , g.gen_bg())
    call s:hi("VisualNOS"                 , g.gen_fg())
    call s:hi("WarningMsg"                , g.gen_fg())
    call s:hi("WildMenu"                  , g.gen_fg())
    call s:hi("Title"                     , g.gen_fg(), "none")
    call s:hi("Conceal"                   , g.gen_fg())
    call s:hi("Cursor"                    , g.gen_bg())
    call s:hi("NonText"                   , g.gen_fg())
    call s:hi("Normal"                    , ["guifg=#e0e0e0", "guibg=#303030"])
    call s:hi("LineNr"                    , g.gen_fg())
    call s:hi("SignColumn"                , g.gen_pair())
    call s:hi("SpecialKey"                , g.gen_fg())
    call s:hi("StatusLine"                , g.gen_pair(), "none")
    call s:hi("StatusLineNC"              , g.gen_pair(), "none")
    call s:hi("VertSplit"                 , g.gen_pair(), "none")
    call s:hi("ColorColumn"               , g.gen_bg(), "none")
    call s:hi("CursorColumn"              , g.gen_bg(), "none")
    call s:hi("CursorLine"                , g.gen_bg(), "none")
    call s:hi("CursorLineNr"              , g.gen_pair())
    call s:hi("PMenu"                     , g.gen_pair(), "none")
    call s:hi("PMenuSel"                  , g.gen_pair())
    call s:hi("TabLine"                   , g.gen_pair(), "none")
    call s:hi("TabLineFill"               , g.gen_pair(), "none")
    call s:hi("TabLineSel"                , g.gen_pair(), "none")

    " Standard syntax highlighting
    call s:hi("Boolean"                   , g.gen_fg())
    call s:hi("Character"                 , g.gen_fg())
    call s:hi("Comment"                   , g.gen_fg())
    call s:hi("Conditional"               , g.gen_fg())
    call s:hi("Constant"                  , g.gen_fg())
    call s:hi("Define"                    , g.gen_fg(), "none")
    call s:hi("Delimiter"                 , g.gen_fg())
    call s:hi("Float"                     , g.gen_fg())
    call s:hi("Function"                  , g.gen_fg())
    call s:hi("Identifier"                , g.gen_fg(), "none")
    call s:hi("Include"                   , g.gen_fg())
    call s:hi("Keyword"                   , g.gen_fg())
    call s:hi("Label"                     , g.gen_fg())
    call s:hi("Number"                    , g.gen_fg())
    call s:hi("Operator"                  , g.gen_fg(), "none")
    call s:hi("PreProc"                   , g.gen_fg())
    call s:hi("Repeat"                    , g.gen_fg())
    call s:hi("Special"                   , g.gen_fg())
    call s:hi("SpecialChar"               , g.gen_fg())
    call s:hi("Statement"                 , g.gen_fg())
    call s:hi("StorageClass"              , g.gen_fg())
    call s:hi("String"                    , g.gen_fg())
    call s:hi("Structure"                 , g.gen_fg())
    call s:hi("Tag"                       , g.gen_fg())
    call s:hi("Todo"                      , g.gen_pair())
    call s:hi("Type"                      , g.gen_fg(), "none")
    call s:hi("Typedef"                   , g.gen_fg())

    " Spelling highlighting
    call s:hi("SpellBad"                  , g.gen_bg(), "undercurl")
    call s:hi("SpellLocal"                , g.gen_bg(), "undercurl")
    call s:hi("SpellCap"                  , g.gen_bg(), "undercurl")
    call s:hi("SpellRare"                 , g.gen_bg(), "undercurl")

endfunction
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
