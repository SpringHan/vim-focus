" Focus on the fragments.
" Author: SpringHan<springchohaku@qq.com>
" Last Change: <+++>
" Version: 1.0.0
" Repository: https://github.com/SpringHan/vim-focus.git
" https://gitee.com/springhan/vim-focus.git
" Lisence: MIT

" Autoload {{{
if exists('g:VimFoucsLoaded')
	finish
endif
let g:VimFoucsLoaded = 1
" }}}

" FUNCTION: s:GetFragments() { Get the fragments that needs to focus } {{{
function! s:GetFragments() abort
	for l:line in readfile(expand('%'))
	endfor
endfunction
