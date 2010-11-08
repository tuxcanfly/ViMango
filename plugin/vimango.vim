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
    let g:vimango_template_prefix = 'templates'
endif

if !exists('g:vimango_grep_cmd')
    let g:vimango_grep_cmd = 'vimgrep'
endif

python << EOF

import vim

def get_view_from_url(line, settings):
    parse_type = line.split(',')[1]
    if parse_type.strip() == 'direct_to_template':
        template = line.split(',')[2].split(":")[1].strip().replace("\"", "").rstrip("}")
        vim_cmd = "%s %s%s" %(settings['open'], settings['templates'], template)
    else:
        parsed = parse_type.split("'")[1]
        num_dots = parsed.count(".")
        if num_dots == 0:
            app = settings['buffer']
            vim_cmd = settings['grep'] + " /def " + parsed + "/g " + app + "/" + "views.py"
        elif num_dots == 1:
            app, urls = parsed.split('.')
            vim_cmd = settings['open'] + " " + settings['apps'] + app + "/" + urls + ".py"
        elif num_dots == 2:
            app, views, func = parsed.split('.')
            vim_cmd = settings['grep'] + " /def " + func + "/g " + settings['apps'] + app + "/" + views + ".py"
    return vim_cmd

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

map <F2> :python main()<CR>j

let &cpo = s:save_cpo

