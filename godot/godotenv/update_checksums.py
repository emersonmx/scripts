#!/usr/bin/env python

import os
import subprocess
import pathlib

from godotenv import get_file_checksum, get_packages, get_cache_path
from godotenv import get_current_dir


def run_command(**kwargs):
    args = kwargs.get('args', [])
    if not args:
        return
    if isinstance(args, str):
        args = [args]
    with subprocess.Popen(**kwargs) as _:
        print(' '.join(args))


def main():
    cache_dir = get_cache_path()
    versions = get_packages()

    for version, platforms in versions.items():
        for platform, types in platforms.items():
            for type, archs in types.items():
                for arch, info in archs.items():
                    command = (
                        ' '.join([
                            './godotenv.py', 'install', '--download-only',
                            '--platform ' + platform, '--type ' + type,
                            '--arch ' + arch, version
                        ])
                    )
                    run_command(args=command, shell=True)

    files = []
    sums_path = os.path.join(cache_dir, 'sums.txt')
    with open(sums_path, 'w+') as f:
        for path in pathlib.Path(cache_dir).glob('*.zip'):
            filename = os.path.basename(path)
            files.append(filename)
            f.write('{}  {}\n'.format(get_file_checksum(path), filename))

    versions_path = os.path.join(get_current_dir(), 'packages.json')
    for f in files:
        print('Updating checksum for file {} ...'.format(f))
        run_command(
            args="nvim --clean -s macro.vim -O {} {}".format(
                sums_path, versions_path
            ),
            shell=True
        )


if __name__ == '__main__':
    main()
