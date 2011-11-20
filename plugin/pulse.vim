" Pulse the cursor line when repeating a search with "n" or "N".
" Based on code I found online. Assumes your status line bg color is normally
" "NONE", as mine is. Adjust the colors as needed.
" The colors in each array are played forward then backward.
" To use simply copy to ~/.vim/plugins/ or ~/vimfiles/plugins/.

nnoremap n nzv:call PulseCursorLine()<cr>
nnoremap N Nzv:call PulseCursorLine()<cr>

if has('gui_running')
    let g:PulseColorList = [ '#2a2a2a', '#333333', '#3a3a3a', '#444444', '#4a4a4a' ]
    let g:PulseColorattr = 'guibg'
else
    let g:PulseColorList = [ 'DarkGrey', 'DarkGrey', 'DarkGrey' ]
    let g:PulseColorattr = 'ctermbg'
endif

function! PulseCursorLine()
    for pulse in g:PulseColorList
        execute 'hi CursorLine ' . g:PulseColorattr . '=' . pulse
        redraw
        sleep 20m
    endfor
    for pulse in reverse(copy(g:PulseColorList))
        execute 'hi CursorLine ' . g:PulseColorattr . '=' . pulse
        redraw
        sleep 20m
    endfor
    execute 'hi CursorLine ' . g:PulseColorattr . '=NONE'
endfunction
