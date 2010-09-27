map <F2> :python get_view_from_url()<CR>
python << EOF

def get_view_from_url():
    import vim
    line = vim.current.line
    parsed = line.split(',')[1].split("'")[1]
    app, views, func = parsed.split('.')
    vim_grep_cmd = "vimgrep /def " + func + "/g apps/" + app + "/" + views + ".py"
    vim.command(vim_grep_cmd)

EOF
