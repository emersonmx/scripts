from setuptools import setup

setup(
    name='bgmusic',
    version='0.1',
    py_modules=['bgmusic'],
    install_requires=[
        'Click',
    ],
    entry_points='''
        [console_scripts]
        bgmusic=bgmusic:cli
    ''',
)
