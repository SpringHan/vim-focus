" Focus on the fragments.
" Author: SpringHan<springchohaku@qq.com>
" Last Change: 2020.7.25
" Version: 1.0.0
" Repository: https://github.com/SpringHan/vim-focus.git
" Lisence: MIT

" Autoload {{{
if exists('g:VimFoucsLoaded')
	finish
endif
let g:VimFoucsLoaded = 1
" }}}

" Commands {{{
command! -nargs=0 -range FocusStart call s:StartFocus()
command! -nargs=0 FocusConvert call s:ConvertBack()
" }}}

" FUNCTION: {{{ s:GetFragments() { Get the fragments that needs to focus }
function! s:GetFragments() abort
	let s:originBuf = bufnr('%')
	let s:focusHeaderLineNr = line("'<")
	let s:focusLastLineNr = line("'>")
	let s:originFileType = &filetype
	let l:focusContent = getline(s:focusHeaderLineNr, s:focusLastLineNr)
	return l:focusContent
endfunction " }}}

" FUNCTION: {{{ s:OpenFocus(type, content) [ `type` is the open type ] { Open
" the focus }
function! s:OpenFocus(type, content) abort
	if a:type != 'buffer' && a:type != 'window'
		return
	endif

	let s:focusBuf = bufadd('Focus')
	call setbufvar(s:focusBuf, '&buflisted', v:true)
	call setbufvar(s:focusBuf, '&buftype', 'nofile')
	call setbufvar(s:focusBuf, '&filetype', s:originFileType)
	if a:type == 'window'
		silent execute "vertical botright split"
	endif

	execute "buf " . s:focusBuf
	call append(0, a:content)
	let l:nowLineContent = getline(1, line('$'))
	if len(l:nowLineContent) != s:focusLastLineNr - s:focusHeaderLineNr + 1 &&
				\ l:nowLineContent[-1] == ''
		silent execute "delete " . line('$')
	endif
	call cursor(1, 0)
	unlet l:nowLineContent
endfunction " }}}

" FUNCTION: {{{ s:NewWindow() { Open the fragments by window }
function! s:NewWindow() abort
	if !exists('g:VimFocusOpenWay') || g:VimFocusOpenWay == 'buffer'
		return
	endif

	let l:focusContent = s:GetFragments()
	call s:OpenFocus('window', l:focusContent)
endfunction " }}}

" FUNCTION: {{{ s:NewBuffer() { Open the fragments by buffer }
function! s:NewBuffer() abort
	if exists('g:VimFocusOpenWay') && g:VimFocusOpenWay == 'window'
		echom "Test"
		return
	endif

	let l:focusContent = s:GetFragments()
	call s:OpenFocus('buffer', l:focusContent)
endfunction " }}}

" FUNCTION: {{{ s:ConvertBack() { Convert the focus fragments back }
function! s:ConvertBack() abort
	if exists('g:VimFocusOpenWay') && g:VimFocusOpenWay != 'buffer' &&
				\ g:VimFocusOpenWay != 'window'
		return
	endif

	let l:currentContent = getline(1, line('$'))
	silent execute "bd! " . s:focusBuf
	silent execute "buf " . s:originBuf
	call deletebufline(s:originBuf, s:focusHeaderLineNr, s:focusLastLineNr)
	call append(s:focusHeaderLineNr - 1, l:currentContent)
	execute "write"
	unlet s:focusBuf s:originBuf s:focusLastLineNr s:focusHeaderLineNr
				\ s:originFileType
endfunction " }}}

" FUNCTION: {{{ s:StartFocus() { Start focus fragments }
function! s:StartFocus() abort
	if !exists('g:VimFocusOpenWay') || g:VimFocusOpenWay == 'buffer'
		call s:NewBuffer()
	else
		call s:NewWindow()
	endif
endfunction " }}}
