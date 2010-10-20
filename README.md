Install:

* Put vimango.vim in $VIMRUNTIME/plugin

Pressing `<F2>` on any urls.py line:

  * `r'^url/$', 'app.views.func', ...`  
      will take you to `func` in app/views.py

  * `r'^app$', include('app.urls'), ...`  
      will take you to app/urls.py

  * `r'index', direct_to_template, {'template_name': 'app/index.html'}, ...`  
      will take you to templates/app/index.html

No settings are imported and no django modules used.

Have fun!

