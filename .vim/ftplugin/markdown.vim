if expand('%:e') ==? 'cmd'
  setlocal textwidth=104
else
  setlocal textwidth=80
endif

setlocal ts=2 sts=2 sw=2 expandtab

inoremap <buffer> <leader>1 #
inoremap <buffer> <leader>2 ##
inoremap <buffer> <leader>3 ###
inoremap <buffer> <leader>4 ####
inoremap <buffer> <leader>5 #####
inoremap <buffer> <leader>6 ######
