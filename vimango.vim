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

if !exists('g:vimango_template_prefix')
    let g:vimango_template_prefix = 'templates'
endif

python << EOF

def get_view_from_url():
    import vim
    line = vim.current.line
    parse_type = line.split(',')[1]
    if parse_type.strip() == 'direct_to_template':
        template = line.split(',')[2].split(":")[1].strip().replace("\"", "").rstrip("}")
        vim_grep_cmd = "open %s%s" %(vim.eval('g:vimango_template_prefix'), template)
    else:
        parsed = parse_type.split("'")[1]
        try:
            app, views, func = parsed.split('.')
            vim_grep_cmd = "vimgrep /def " + func + "/g " + vim.eval('g:vimango_app_prefix') + app + "/" + views + ".py"
        except ValueError:
            app, urls = parsed.split('.')
            vim_grep_cmd = "open " + vim.eval('g:vimango_app_prefix') + app + "/" + urls + ".py"
    vim.command(vim_grep_cmd)

EOF

map <F2> :python get_view_from_url()<CR>j

