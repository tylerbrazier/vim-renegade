if exists("g:loaded_renegade") || &cp
	finish
endif
let g:loaded_renegade = 1

silent! nnoremap <unique> <Leader>gl :R git log <Up>
silent! vnoremap <unique> <Leader>gl :Range git log -L <,>:% <Up>
silent! nnoremap <unique> <Leader>go :R git show <C-R><C-W>
silent! nnoremap <unique> <Leader>gb :tab .R git blame --date short %<CR>
silent! nnoremap <unique> <Leader>gq :Review<Up>
silent! nnoremap <unique> <Leader>gd :diffthis<CR>
			\:vert .R git show HEAD:./%<CR>
			\:diffthis<CR>

command -count -nargs=+ -complete=file R
	\ exe '<mods> new +setl\ ft='..(<count> > 0 ? &ft : 'git')
	\|exe 'file R'..bufnr() <q-args>
	\|exe 'silent r !' <q-args>
	\|1d _
	\|setl buftype=nofile bufhidden=wipe nomodifiable
	\|<count>

command -range -nargs=+ -complete=file Range
	\ let args = substitute(<q-args>, '<', <line1>, 'g')
	\|let args = substitute(args,     '>', <line2>, 'g')
	\|exe 'R' args

command -bang -nargs=? -complete=file Review
			\ call Review(empty('<bang><args>'), <q-args>)

function Review(condense, file)
	" first gather the new files if no file was given
	let result = empty(a:file)
			\ ? systemlist('git status --porcelain -u')
			\   ->filter('v:val =~ "^??"')
			\   ->map('v:val[3:].."|1| [New file]"')
			\ : []
	let cmd = 'git -P diff -U0'
	if !empty(a:file)
		let cmd ..= ' -- '..shellescape(a:file)
	endif
	let diff = systemlist(cmd)

	" creates a quickfix line from diff[i] with format "file|line| message"
	let QFLine = { f, i -> f..
				\'|'..matchstr(diff[i], '+\d\+')[1:]..
				\'| '..diff[i+1] }

	for i in range(len(diff))
		if diff[i] =~ '^+++ b'
			let f = diff[i][6:]
			if a:condense
				call add(result, QFLine(f, i+1))
			endif
		elseif !a:condense && diff[i] =~ '^@@'
			call add(result, QFLine(f, i))
		endif
	endfor
	copen
	cexpr result
endfunction
