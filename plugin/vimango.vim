" File:          vimango.vim
" Author:        Jakh Daven<tuxcanfly@gmail.com>
" Version:       0.1~dev
" Description:   Django project navigation helper
"                Currently supports navigating to view
"                from urls
" License:	     This file is licensed under BSD License

let s:save_cpo = &cpo
set cpo&vim

if exists("loaded_vimango")
    finish
endif
let loaded_vimango = 1

if !exists('g:vimango_app_prefix')
    let g:vimango_app_prefix = ''
endif

if !exists('g:vimango_open_cmd')
    let g:vimango_open_cmd = 'tabnew'
endif

if !exists('g:vimango_template_prefix')
    let g:vimango_template_prefix = 'templates/'
endif

if !exists('g:vimango_grep_cmd')
    let g:vimango_grep_cmd = 'vimgrep'
endif

python << EOF

import vim

from vimango import get_view_from_url

def main():
    line = vim.current.line
    settings = {}
    settings['open'] = vim.eval('g:vimango_open_cmd')
    settings['grep'] = vim.eval('g:vimango_grep_cmd')
    settings['templates'] = vim.eval('g:vimango_template_prefix')
    settings['apps'] = vim.eval('g:vimango_app_prefix')
    settings['buffer'] = vim.current.buffer.name.split('/')[-2]
    vim.command(get_view_from_url(line, settings))

EOF

noremap gO :python main()<CR>jzz

let &cpo = s:save_cpo

