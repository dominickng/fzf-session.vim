" vim:fdm=marker

" fzf-session.vim - fzf extension to manage vim sessions.
" Inspired by ctrlp_session by Pascal Lalancette
" Maintainer:       Dominick Ng
" Version:          1.0

" Return sessions location path {{{
function! fzf_session#path()
    if !exists('g:fzf_session_path')
        return expand('%:h')
    endif
    return g:fzf_session_path
endfunction
"}}}

" Return a session file path from its name {{{
function! s:session_file(name)
    let l:file = fzf_session#path()."/".a:name
    return fnamemodify(expand(l:file), ':p')
endfunction
"}}}

" Create a session {{{
function! fzf_session#create(name)
    echo 'Tracking session '.a:name
    let g:this_fzf_session = s:session_file(a:name)
    let g:this_fzf_session_name = a:name
    call fzf_session#persist()
endfunction
"}}}

" Load a session {{{
function! fzf_session#load(name)
    " Disable persistence while loading session to avoid conflicts and
    " potential crashes.
    if exists('g:this_fzf_session')
        call fzf_session#quit()
    endif
    exec("source ".s:session_file(a:name))
    let g:this_fzf_session_name = a:name
endfunction
"}}}

" Delete a session {{{
function! fzf_session#delete(name)
    echo 'Deleting session in '.a:name
    let l:session_file = s:session_file(a:name)
    if exists('g:this_fzf_session') && l:session_file == g:this_fzf_session
        " The deleted session is the active one. Make sure it does not
        " magically reappear!
        call fzf_session#quit()
    endif
    call delete(l:session_file)
endfunction
"}}}

" Quit current active session and reset Vim. {{{
function! fzf_session#quit()
    if !exists('g:this_fzf_session')
        echomsg "No active session to quit"
        return
    endif
    unlet g:this_fzf_session
    unlet g:this_fzf_session_name
    try
        " Delete all previous buffers
        exec("silent! bufdo bwipeout")
    catch
        echohl WarningMsg
        echomsg "Could not delete all buffers while leaving session."
        echohl None
        return
    endtry
endfunction
"}}}

" List all persisted sessions {{{
function! fzf_session#list()
    let l:wildignore=&wildignore
    set wildignore=
    let l:session_files = split(globpath(fzf_session#path(), "*"))
    let l:result = map(l:session_files, "fnamemodify(expand(v:val), ':t:r')")
    let &wildignore = l:wildignore
    return l:result
endfunction
"}}}

" Take a snapshot of Vim state and persist on disk {{{
function! fzf_session#persist()
  if exists('g:this_fzf_session')
    let sessionoptions= &sessionoptions
    try
      set sessionoptions-=blank sessionoptions-=options
      execute 'mksession! '.fnameescape(g:this_fzf_session)
      call writefile(insert(readfile(g:this_fzf_session), 'let g:this_fzf_session =v:this_session', -2), g:this_fzf_session)
    catch
      unlet g:this_fzf_session
      unlet g:this_fzf_session_name
      echoerr string(v:exception)
    finally
      let &sessionoptions=sessionoptions
    endtry
  endif
  return ''
endfunction
"}}}
