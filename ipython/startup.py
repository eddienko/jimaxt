import importlib
import itertools
import platform
import subprocess

import pip
from IPython.core.magic import Magics, cell_magic, line_magic, magics_class
from IPython.core.magic_arguments import (argument, magic_arguments,
                                          parse_argstring)

try:
    from isort import SortImports
    isort = True
except:
    isort = False


@magics_class
class CustomMagics(Magics):

    @line_magic
    def theme(self, line):
        if not line:
            res = subprocess.run("jupyter_themer -l",
                                 shell=True, stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE)
            if res.returncode == 0:
                print(res.stdout.decode())
        else:
            res = subprocess.run("jupyter_themer -t {}".format(line),
                                 shell=True, stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE)
        if res.returncode != 0:
            print(res.stderr.decode())

    @magic_arguments()
    @argument('-s', '--silent', action='store_true',
              help='perform installation silently')
    @argument('pkg', type=str, help='Package to install')
    @line_magic
    def install(self, line):
        """Install a package locally."""
        args = parse_argstring(self.install, line)
        a = subprocess.run("pip install --user {}".format(args.pkg),
                           shell=True, stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE)
        if a.returncode == 0:
            if not args.silent:
                print(a.stdout.decode())
        else:
            print(a.stderr.decode())

    @magic_arguments()
    @argument('-p', '--packages', nargs='+', type=str,
              help='List of packages')
    @line_magic
    @line_magic
    def info_versions(self, line):
        def _pprint(key, val):
            print("{:30s}: {}".format(key, val))

        _pprint("Python", "{} {} {}".format(platform.python_version(),
                                            platform.architecture()[0],
                                            platform.python_compiler()))
        _pprint("OS", platform.platform().replace('-', ' '))
        print()
        args = parse_argstring(self.info_versions, line)
        packages = args.packages
        if not packages:
            packages = ['numpy', 'scipy', 'matplotlib', 'sklearn',
                        'pandas', 'astropy', 'tensorflow']
        res = {}
        for pkg in sorted(packages):
            try:
                version = importlib.__import__(pkg)
            except:
                res[pkg] = 'Package not found'
            else:
                try:
                    res[pkg] = version.__version__
                except:
                    res[pkg] = None

        for k in res:
            _pprint(k, res[k])

    @line_magic
    def list_packages(self, line):
        installed_packages = pip.get_installed_distributions()
        installed_packages_list = sorted(["\033[95m%s\033[0m==%s" % (i.key, i.version)
                                          for i in installed_packages if len(i.key) < 20])
        res = [installed_packages_list[3 * i:3 * (i + 1)]
               for i in range(len(installed_packages_list) // 3 + 1)]
        for r in res:
            print(''.join([*map(lambda x: f'{x:40s}', r)]))

    @line_magic
    def sci(self, line):
        s = {}
        s['numpy'] = ["import numpy as np"]
        s['pandas'] = ["import pandas as pd"]
        s['matplotlib'] = ["import matplotlib as mpl",
                           "import seaborn as sns",
                           "from matplotlib import pylab, mlab, pyplot",
                           "from matplotlib import pyplot as plt"]
        s['astropy'] = ["import astropy"]
        s['scipy'] = ["import scipy"]
        s['tensorflow'] = ["import tensorflow as tf"]
        s['pyarrow'] = ["import pyarrow as pa", "import pyarrow.parquet as pq"]
        s['dask'] = ['from dask import delayed', 
                     'import dask.array as da', 
                     'import dask.dataframe as dd']
        if not line:
            cmd = '\n'.join(itertools.chain(*s.values()))
        else:
            cmd = '\n'.join(itertools.chain(*[s[k] for k in line.split()]))
        if isort:
            cmd = SortImports(file_contents=cmd).output
        if 'matplotlib' in line:
            cmd = cmd + '\n%matplotlib inline'
        self.shell.set_next_input('# %sci {}\n{}'.format(line, cmd), replace=True)



if __name__ == '__main__':
    from IPython import get_ipython
    get_ipython().register_magics(CustomMagics)

