scriptencoding utf-8

if has('nvim')
  function! coc#ui#echo_messages(hl, msgs) abort
    if empty(a:msgs) | return | endif
    let level = 'info'
    if a:hl =~# 'Error'
      let level = 'error'
    elseif a:hl =~# 'Warning'
      let level = 'warn'
    endif
    let msg = join(a:msgs, "\n")
    call v:lua.vim.notify(msg, level, {'title': 'CoC'})
  endfunction

  function! coc#ui#echo_lines(lines) abort
    if empty(a:lines) | return | endif
    let msg = join(a:lines, "\n")
    call v:lua.vim.notify(msg, 'info', {'title': 'CoC'})
  endfunction
endif
