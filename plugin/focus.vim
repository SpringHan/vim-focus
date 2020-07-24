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

" Commands {{{
" }}}

" FUNCTION: s:GetFragments() { Get the fragments that needs to focus } {{{
function! s:GetFragments() abort
	let s:focusHeaderLineNr = line("'<")
	let l:focusContent = []
	let l:fileContent = readfile(expand('%'))
	for l:line in l:fileContent
		if exists('l:check') && l:check > 0
			call add(l:focusContent, l:line)
			l:check -= 1
		endif

		if index(l:fileContent, l:line) + 1 == line("'<")
			call add(l:focusContent, l:line)
			let l:check = line("'>") - line("'<") + 1
		endif
	endfor
	return l:focusContent
endfunction " }}}

" FUNCTION: s:NewWindow() { Open the fragments by window } {{{
function! s:NewWindow() abort
	if !exists('g:VimFocusOpenWay') || g:VimFoucsOpenWay == 'buffer'
		return
	endif

	call s:GetFragments()
endfunction " }}}

" FUNCTION: s:NewBuffer() { Open the fragments by buffer } {{{
function! s:NewBuffer() abort
	if exists('g:VimFoucsOpenWay') && g:VimFoucsOpenWay == 'window'
		return
	endif

	call s:GetFragments()
endfunction " }}}
