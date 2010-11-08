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

