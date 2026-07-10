setlocal ts=4 sts=4 sw=4 expandtab textwidth=100

noremap <buffer> <leader>iu :UnusedImports<cr>
noremap <buffer> <leader>ir :UnusedImportsRemove<cr>
noremap <buffer> <leader>ih :UnusedImportsReset<cr>
noremap <buffer> <leader>fa :call FinalField()<cr>

inoremap <buffer> <leader>cc private static final Clock CLOCK = Clock.fixed(Instant.parse("2020-06-04T14:30:30.000Z"), ZoneId.of("UTC"));
