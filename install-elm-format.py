import sys
import subprocess
import os.path as op

url_tmpl = 'https://github.com/avh4/elm-format/releases/download/0.5.2-alpha/elm-format-0.18-0.5.2-alpha-{platform}-x64.tgz'

def run(cmd):
    subprocess.call(cmd, shell=isinstance(cmd, str))

if sys.platform == 'darwin':
    url = url_tmpl.format(platform='mac') + 'elm-format-0.18-0.5.2-alpha-mac-x64.tgz'
else:
    url = url_tmpl.format(platform='linux')

if not op.exists('elm-format'):
    run('wget -O elm-format.tgz {}'.format(url))
    run('tar -xf elm-format.tgz')
    
run('mv elm-format /usr/local/bin')