# -*- mode: python ;-*-

import os
import sys
import site

# Some libraries (eg. geopy) have an annoying habit of printing to stdout,
# which is a no-no under mod_wsgi.
# Workaround as per http://code.google.com/p/modwsgi/wiki/ApplicationIssues
sys.stdout = sys.stderr

# Try to find a virtualenv in our parent chain.
env_root = "/srv/openblock/virtualenv"

sitepackages_root = os.path.join(env_root, 'lib')
assert os.path.exists(sitepackages_root), "no such dir %s" % sitepackages_root
for d in os.listdir(sitepackages_root):
    if d.startswith('python'):
        site.addsitedir(os.path.join(sitepackages_root, d, 'site-packages'))
        break
else:
    raise RuntimeError("Could not find any site-packages to add in %r" % env_root)

os.environ['DJANGO_SETTINGS_MODULE'] = 'obdemo.settings'
os.environ['PYTHON_EGG_CACHE'] = '/tmp/obdemo-python-eggs'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()

