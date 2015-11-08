Install:

* Put vimango.vim in $VIMRUNTIME/plugin  
    using vundle would be better

* Put vimango.py in $PYTHONPATH  
    e.g. sudo ln -sf ~/.vim/bundle/ViMango/plugin/vimango.py /usr/local/lib/python2.7/dist-packages/vimango.py

keymap is `gO` on any urls.py line:

  * `r'^url/$', 'app.views.func', ...`  
      will take you to `func` in app/views.py

  * `r'^app$', include('app.urls'), ...`  
      will take you to app/urls.py

  * `r'index', direct_to_template, {'template_name': 'app/index.html'}, ...`  
      will take you to templates/app/index.html

only work good with str style of view at one line
so, django and web.py's url can be parsed.

No settings are imported and no django modules used.
see the source, for more detail.

Have fun!

