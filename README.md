# renegade.vim

Simple featherweight (<50 lines) alternative to
[fugitive](https://github.com/tpope/vim-fugitive).

- `<Leader>gb` git blame the current file in a new tab
- `<Leader>gd` git diff the current file side by side
- `<Leader>gs` git status in quickfix list
- `<Leader>gl` git log (works on visual selection)
- `<Leader>go` git show object (hash) under the cursor (after log/blame)

All of these (except status) use the command `:R` which works like `:r !` and

- outputs to a new scratch window
- accepts modifiers like `:tab` and `:vert`
- takes a count to put the cursor on that line; `:.R git blame %` leverages
  this to start the cursor on the same line as the blamed file
- takes a range and replaces any `<`/`>` in the command with start/end of range
  e.g. `:R git log -L <,>:%` in visual mode to see the history of selected lines

## Why?

- fugitive is bloated
- it also leaves behind a lot of garbage buffers (check `:ls!`);
  the `:R` buffer gets wiped out when you leave it
- `:term` always wraps text so diff and blame don't work
- `:term` has reflow issues when resizing windows
- `:term` has limited scrollback so log always needs `-n` for big repos
- vim is already great at working with text, so just put git's output in vim

## Ideas

- `:R git ls-files` and `gf` to edit a file in the window
- `:R` isn't limited to git commands
