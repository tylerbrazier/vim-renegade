if exists("g:loaded_renegade") || &cp
	finish
endif
let g:loaded_renegade = 1

command -count -nargs=+ -complete=file R
	\ <mods> new
	\|setl buftype=nofile bufhidden=wipe
	\|exe 'r !'<q-args>
	\|1d _
	\|filetype detect
	\|<count>

silent! nnoremap <unique> <Leader>gb :tab .R git blame %<CR>
silent! nnoremap <unique> <Leader>gl :tab R git log <Up>
silent! nnoremap <unique> <Leader>go :R git show <cWORD><CR>
silent! nnoremap <unique> <Leader>gd :vertical R git show HEAD:%<CR>
			\:diffthis<CR><C-W>p:diffthis<CR>

augroup renegade
	autocmd!
	autocmd VimEnter,DirChanged * call s:SetOpts()
augroup END

function s:SetOpts()
	let l:cmd = 'git rev-parse --show-toplevel'
	let s:proj_root = shellescape(trim(system(l:cmd)))
	if v:shell_error
		" not in a git project
		" TODO restore previous opts (unless user changed them since)
		return
	endif

	" if it was a dir change within the same project, don't bother
	if exists('s:old_proj_root') && s:old_proj_root == s:proj_root
		return
	endif
	let s:old_proj_root = s:proj_root

	" set the path to all the dirs in the project
	let l:cmd = 'git -C '.s:proj_root.' ls-tree -rd --name-only HEAD'
	let &path = join(systemlist(l:cmd), ',').',,'

	set grepprg=git\ grep\ -I\ -n\ --column
	set grepformat=%f:%l:%c:%m
endfunction
