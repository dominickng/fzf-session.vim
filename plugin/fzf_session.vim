" fzf-session.vim - fzf extension to manage vim sessions.
" Inspired by ctrlp_session by Pascal Lalancette
" Maintainer:       Dominick Ng
" Version:          1.0

" Location of session files
" let g:fzf_session_path="~/.vim_sessions"

" ------------------------------------------------------------------
" Sessions
" ------------------------------------------------------------------

let s:default_action = {
  \ 'ctrl-x': 'delete',
  \ 'ctrl-s': 'save' }

function! s:session_handler(lines)
  " a:lines is a list of ['', '', <result>]. If there is no result, a:lines
  " has the format [<query>, '']
  if len(a:lines) == 0
    return
  elseif len(a:lines) == 2
    execute fzf_session#create(a:lines[0])
    return
  endif

  let cmd = get(get(g:, 'fzf_action', s:default_action), a:lines[1], 'e')

  if cmd == 'delete'
    execute fzf_session#delete(a:lines[2])
  elseif cmd == 'save'
    execute fzf_session#create(a:lines[2])
  else
    execute fzf_session#load(a:lines[2])
  endif
endfunction

function! fzf_session#session()
  let raw_dir = fzf_session#path()
  if !isdirectory(expand(raw_dir))
    return s:warn('Invalid directory')
  endif
  let dir = substitute(raw_dir, '/*$', '/', '')

  return fzf#run(fzf#vim#wrap({
  \ 'source':  fzf_session#list(),
  \ 'sink*':   function('s:session_handler'),
  \ 'options': '-m --prompt \> --print-query',
  \ 'dir': dir
  \}))
endfunction

augroup fzf_session
  autocmd!
  autocmd BufEnter,VimLeavePre * call fzf_session#persist()
augroup END

command! -nargs=1 Session call fzf_session#create(<f-args>)
command! -nargs=0 Sessions call fzf_session#session()
command! -nargs=1 SLoad call fzf_session#load(<f-args>)
command! -nargs=1 SDelete call fzf_session#delete(<f-args>)
command! -nargs=0 SQuit call fzf_session#quit()
command! -nargs=0 SList echo join(fzf_session#list(), ", ")
