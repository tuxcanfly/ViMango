" File:          vimango.vim
" Author:        Jakh Daven<tuxcanfly@gmail.com>
" Version:       0.1~dev
" Description:   Django project navigation helper
"                Currently supports navigating to view
"                from urls
"

if !exists('g:vimango_app_prefix')
    let g:vimango_app_prefix = ''
endif

python << EOF

def get_view_from_url():
    import vim
    line = vim.current.line
    parsed = line.split(',')[1].split("'")[1]
    try:
        app, views, func = parsed.split('.')
        vim_grep_cmd = "vimgrep /def " + func + "/g " + vim.eval('g:vimango_app_prefix') + "/" + app + "/" + views + ".py"
    except ValueError:
        app, urls = parsed.split('.')
        vim_grep_cmd = "open " + vim.eval('g:vimango_app_prefix') + "/" + app + "/" + urls + ".py"
    vim.command(vim_grep_cmd)

EOF

map <F2> :python get_view_from_url()<CR>jf

