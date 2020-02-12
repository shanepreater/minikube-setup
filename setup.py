# -*- encoding: utf-8 -*-
from __future__ import absolute_import
from __future__ import print_function

import io
import re
from glob import glob
from os.path import basename
from os.path import dirname
from os.path import join
from os.path import splitext

from setuptools import find_packages
from setuptools import setup


def read(*names, **kwargs):
    with io.open(
            join(dirname(__file__), *names),
            encoding=kwargs.get('encoding', 'utf8')
    ) as fh:
        return fh.read()


setup(
    name='kubehello',
    version='1.0.0',
    license='BSD-2-Clause',
    description='An example package. Generated with cookiecutter-pylibrary.',
    long_description=read('README.md'),
    long_description_content_type="text/markdown",
    author='Shane Preater',
    author_email='shane.preater@gmail.com',
    url='https://github.com/shanepreater/minikube-setup',
    packages=find_packages('src'),
    package_dir={'': 'src'},
    py_modules=[splitext(basename(path))[0] for path in glob('src/*.py')],
    include_package_data=True,
    zip_safe=False,
    classifiers=[
        # complete classifier list: http://pypi.python.org/pypi?%3Aaction=list_classifiers
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'Operating System :: Unix',
        'Operating System :: POSIX',
        'Operating System :: Microsoft :: Windows',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: Implementation :: CPython',
        'Programming Language :: Python :: Implementation :: PyPy',
        'Topic :: Example Applications',
    ],
    project_urls={
        'Changelog': 'https://github.com/shanepreater/minikube-setup/blob/master/CHANGELOG.md',
        'Issue Tracker': 'https://github.com/shanepreater/minikube-setup/issues',
    },
    keywords=[
        'coding test', 'example app', 'hello world'
    ],
    python_requires='>=3.7.0, !=2.*',
    install_requires=[
        "fastapi>=0.48.0",
        "uvicorn>=0.11.2"
    ],
    extras_require={
        # eg:
        #   'rst': ['docutils>=0.11'],
        #   ':python_version=="2.6"': ['argparse'],
    },
    setup_requires=[
        'pytest-runner',
        'nose'
    ],
    entry_points={
        'console_scripts': [
            'helloworld = kubehello.main:hello_world',
            'start-server = kubehello.main:start'
        ]
    },
)