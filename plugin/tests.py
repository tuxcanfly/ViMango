import unittest

from vimango import get_view_from_url

class VimangoTestCase(unittest.TestCase):
    def setUp(self):
        self.settings = {}
        self.settings['open'] = "tabnew"
        self.settings['grep'] = "vimgrep"
        self.settings['templates'] = "templates/"
        self.settings['apps'] = "apps/"
        self.settings['buffer'] = "about"

    def test_get_func(self):
        self.line = "url(r'^invest/', 'contact_form.views.invest'),"
        print get_view_from_url(self.line, self.settings)

    def test_get_app_urls(self):
        self.line = "url(r'^about/', include('about.urls')),"
        print get_view_from_url(self.line, self.settings)

    def test_get_direct_template(self):
        self.line = """url(r'^$', direct_to_template, {"template": "homepage.html"}, name="home"),"""
        print get_view_from_url(self.line, self.settings)

if __name__ == '__main__':
    unittest.main()
