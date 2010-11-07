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

python << endpython
import vim
import re

def get_view_prefix():
    ''' Return the view prefix or None '''
    # Find the pattern
    b = vim.current.buffer
    w = vim.current.window
    (line, col) = w.cursor
    while (line > 0):
        l = b[line]
        match = re.search("patterns\([\'\"]([\w\.]*)[\'\"]", l)
        if match is not None:
            # Found a patterns line
            prefix = match.groups()[0]
            return prefix
        line = line - 1
    return None

def get_view_from_url():
    line = vim.current.line
    parse_type = line.split(',')[1]
    if parse_type.strip() == 'direct_to_template':
        template = line.split(',')[2].split(":")[1].strip().replace("\"", "").rstrip("}")
        vim_grep_cmd = "%s %s%s" %(vim.eval('g:vimango_open_cmd'), vim.eval('g:vimango_template_prefix'), template)
    elif parse_type.strip().startswith('include'):
        view_func = parse_type.split("'")[1]
        app, urls = view_func.split('.')
        vim_grep_cmd = vim.eval('g:vimango_open_cmd') + " " + vim.eval('g:vimango_app_prefix') + app + "/" + urls + ".py"
    else:
        prefix = get_view_prefix()
        view_func = parse_type.split("'")[1]
        if prefix is not None and prefix is not '':
            view_func = prefix + '.' + view_func
        view_func_split = view_func.split('.')
        site_name = vim.current.buffer.name.split('/')[-2]
        if site_name == view_func_split[0]:
            view_func = '.'.join(view_func_split[1:])
        num_dots = view_func.count(".")
        if num_dots == 1:
            views, func = view_func.split('.')
            vim_grep_cmd = "vimgrep /def " + func + "/g " + vim.eval('g:vimango_app_prefix') + views + ".py"
        elif num_dots == 2:
            app, views, func = view_func.split('.')
            vim_grep_cmd = "vimgrep /def " + func + "/g " + vim.eval('g:vimango_app_prefix') + app + "/" + views + ".py"
    vim.command(vim_grep_cmd)

endpython

map <F3> :python get_view_from_url()<CR>j

let &cpo = s:save_cpo

