if exists("g:loaded_renegade") || &cp
	finish
endif
let g:loaded_renegade = 1

silent! nnoremap <unique> <Leader>gl :R git log <Up>
silent! vnoremap <unique> <Leader>gl :R git log -L <,>:% <Up>
silent! nnoremap <unique> <Leader>go :R git show <C-R><C-W>
silent! nnoremap <unique> <Leader>gb :tab .R git blame --date short %<CR>
silent! nnoremap <unique> <Leader>gs :cexpr Rstatus()<CR>
silent! nnoremap <unique> <Leader>gd :diffthis<CR>
			\:vertical R git show HEAD:./%<CR>
			\:diffthis<CR>

command -range -bang -nargs=+ -complete=file R
	\ call R(<q-args>, '<bang>', '<mods>', <range>, <line1>, <line2>)

function R(cmd, bang, mods, range, line1, line2)
	exe empty(a:bang) ? a:mods..' new' : 'enew'

	" e.g. visual :'<,'>R git log -L <,>:%
	let cmd = substitute(a:cmd, '<', a:line1, 'g')
	let cmd = substitute(cmd, '>', a:line2, 'g')

	" include bufnr to make the name unique
	exe 'file R'..bufnr() cmd

	exe 'silent r !' cmd
	1d _ "delete first empty line

	setl buftype=nofile bufhidden=wipe nomodifiable
	filetype detect "for highlighting

	" if count was given (range==1) go to that line number (line2==count)
	exe a:range == 1 ? a:line2 : 1
endfunction

function Rstatus()
	" gather the new files first
	let result = systemlist('git status --porcelain -u')
				\->filter('v:val =~ "^??"')
				\->map('v:val[3:].."|1| [New file]"')
	let diff = systemlist('git -P diff -U0')
	for i in range(len(diff))
		if diff[i] !~ '^+++ b'
			continue
		endif
		let f = diff[i][6:]
		let l = matchstr(diff[i+1], '+\d\+')[1:]
		let m = diff[i+2]
		call add(result, f..'|'..l..'| '..m)
	endfor
	return result
endfunction
