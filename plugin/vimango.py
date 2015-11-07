def get_view_from_url(line, settings):
    def file_grep_wrapper(file_grep):
        import os
        is_file = os.path.exists(file_grep)
        del os
        if not is_file:
            return '../' + file_grep
        return file_grep

    def get_vim_cmd(func, file_grep):
        return settings['grep'] + " /\(def\|class\) \+" + func + "/g " + file_grep_wrapper(file_grep)

    def find_quote(oneline):
        for an_alpha in oneline:
            if an_alpha is "'":
                return "'"
                break
            elif an_alpha is "\"":
                return "\""
                break

    vim_cmd = 'echo "sorry, i tried..."'
    quote_id = find_quote(line)
    #prune re str for some special char
    line = line[line.index(quote_id, line.index(quote_id)+1):]
    parse_type = line.split(',')[1]
    if parse_type.strip() == 'direct_to_template':
        import re
        template = re.sub('''('|"|}\)?$)''', '', line.split(',')[2].split(':')[1].strip())
        file_grep = '%s%s%s' % (settings['apps'], settings['templates'], template)
        vim_cmd = '%s %s' %(settings['open'], file_grep_wrapper(file_grep))
        del re
    else:
        parse_list = parse_type.split(find_quote(parse_type))
        parsed = parse_list[1]
        num_dots = parsed.count(".")
        if num_dots == 0:
            app = settings['buffer']
            vim_cmd = settings['grep'] + " /\(def\|class\) \+" + parsed + "/g " + app + "/" + "views.py"
        elif num_dots == 1:
            app_or_views, urls_or_func = parsed.split('.')
            if 'include(' in parse_list[0]:
                file_grep = settings['apps'] + app_or_views + "/" + urls_or_func + ".py"
                vim_cmd = settings['open'] + " " + file_grep_wrapper(file_grep)
            else:
                file_grep = settings['apps'] + app_or_views + ".py"
                vim_cmd = get_vim_cmd(urls_or_func, file_grep)
        elif num_dots >= 2:
            parsed_list = parsed.split('.')
            the_view = parsed_list[0:-1]
            file_grep = settings['apps'] + '/'.join(the_view) + ".py"
            vim_cmd = get_vim_cmd(parsed_list[-1], file_grep)
    return vim_cmd

