if exists("g:loaded_renegade") || &cp
	finish
endif
let g:loaded_renegade = 1

silent! nnoremap <unique> <Leader>gl :R git log <Up>
silent! vnoremap <unique> <Leader>gl :Range git log -L <,>:% <Up>
silent! nnoremap <unique> <Leader>gb :tab .R git blame --date short %<CR>:setl cul<CR>
silent! nnoremap <unique> <Leader>go :R git show --diff-merges=on <cword><CR>
silent! nnoremap <unique> <Leader>ga :!git add %<CR>
silent! nnoremap <unique> <Leader>gr :!git restore %
silent! nnoremap <unique> <Leader>gd :Relative <Up>
silent! nnoremap <unique> <Leader>gq :Report<Up>

command -count -bang -nargs=+ -complete=file R
	\ exe '<mods> new'
	\|exe 'file R'..bufnr() <q-args>
	\|exe 'silent r !' <q-args>
	\|1d _
	\|exe 'setl noma bt=nofile bh=wipe ft='..('<bang>'=='!' ? '' : 'git')
	\|<count>

command -range -nargs=+ -complete=file Range
	\ let args = substitute(<q-args>, '<', <line1>, 'g')
	\|let args = substitute(args,     '>', <line2>, 'g')
	\|exe 'R' args

command -nargs=? -complete=file Relative
	\ diffthis
	\|exe 'vert .R! git show' shellescape(('<args>' ?? 'HEAD')
	\ ..':./'..expand('%'))
	\|let &ft = getbufvar('#', '&filetype')
	\|diffthis

command -bang -nargs=? -complete=file Report call Report('<bang>', <q-args>)

function Report(incl_untracked, diff_args)
	let result = []
	if !empty(a:incl_untracked)
		" git diff can't show untracked files so use git status
		let status = systemlist('git status --porcelain -u')
		if v:shell_error | throw string(status) | endif
		let result = status
				\->filter('v:val =~ "^??"')
				\->map('v:val[3:].."|1|[Untracked]"')
	endif

	let diff = systemlist('git -P diff --relative -U0 '..
				\ shellescape(a:diff_args ?? 'HEAD'))
	if v:shell_error | throw string(diff) | endif

	for i in range(len(diff))
		if diff[i] =~ '^+++ b'
			let file = diff[i][6:]
			let line = matchstr(diff[i+1], '+\d\+')[1:]
			let message = diff[i+2]
			call add(result, file..'|'..line..'|'..message)
		elseif diff[i] =~ '^+++ /dev/null'
			let file = diff[i-1][6:]
			call add(result, file..'|1|[Deleted]')
		endif
	endfor

	if len(result) > 0
		copen
		let saved_efm = &errorformat
		let &errorformat = '%f|%l|%m'
		cexpr result
		let &errorformat = saved_efm
	else
		cclose
		echo 'No changes'
	endif
endfunction
