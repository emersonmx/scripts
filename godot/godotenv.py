#!/usr/bin/env python

import os
import sys
import json
import argparse
import hashlib


def data_get(array, key, default=None):
    if not isinstance(array, dict):
        return default
    if key is None:
        return array
    if key in array:
        return array[key]
    if '.' not in key:
        return array[key] if key in array else default

    for segment in key.split('.'):
        if isinstance(array, dict) and segment in array:
            array = array[segment]
        else:
            return default

    return array


class SubcommandHelpFormatter(argparse.RawDescriptionHelpFormatter):
    def _format_action(self, action):
        parts = super()._format_action(action)
        if action.nargs == argparse.PARSER:
            parts = '\n'.join(parts.split('\n')[1:])
        return parts


def get_current_dir():
    return os.path.dirname(os.path.realpath(__file__))


def get_cache_path():
    cache_path = os.path.join(get_current_dir(), 'cache')
    os.makedirs(cache_path, exist_ok=True)
    return cache_path


def get_bin_path():
    bin_path = os.path.join(get_current_dir, 'bin')
    os.makedirs(bin_path, exist_ok=True)
    return bin_path


def get_versions():
    with open('versions.json') as f:
        return json.load(f)


def get_latest_stable_version():
    return '3.2.1-stable'


def get_package_info(version, platform, type, arch):
    versions = get_versions()
    version = version if version else get_latest_stable_version()
    platform = platform if platform else 'linux'
    type = type if type else 'standard'
    arch = arch if arch else '64'
    return data_get(
        versions.get(version, {}), '{}.{}.{}'.format(platform, type, arch)
    )


def get_file_checksum(filename):
    hash_md5 = hashlib.md5()
    with open(filename, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


def check_file(filename, checksum):
    return get_file_checksum(filename).lower() == checksum.lower()


def download(url):
    import time
    import urllib.request

    def reporthook(count, block_size, total_size):
        global start_time
        if count == 0:
            start_time = time.time()
            return

        duration = time.time() - start_time
        progress_size = int(count * block_size)
        speed = int(progress_size / (1024 * duration))
        percent = int(count * block_size * 100 / total_size)
        eta_secs = int((total_size - progress_size) / 1024 / speed)
        eta_min = eta_secs / 60
        eta_str = '{:3d} {}'.format(
            eta_secs if eta_secs < 60 else int(eta_min),
            'seconds' if eta_secs < 60 else 'minutes'
        )
        sys.stdout.write(
            '\r[{:3d}%] Downloaded: {:.2f} MB,'
            ' Total: {:.2f} MB,'
            ' Speed: {:.0f} KB/s,'
            ' ETA: {}'.format(
                percent, progress_size / (1024 * 1024),
                total_size / 1024 / 1024, speed, eta_str
            )
        )
        sys.stdout.flush()

    print('Downloading {}'.format(url))
    filename = os.path.join(get_cache_path(), os.path.basename(url))
    result, _ = urllib.request.urlretrieve(url, filename, reporthook)
    print('\n')
    return result


def download_package(package):
    url = package.get('url')
    checksum = package.get('checksum')
    filename = os.path.join(get_cache_path(), os.path.basename(url))
    if os.path.exists(filename):
        if get_file_checksum(filename).lower() == checksum.lower():
            return filename

    return download(url)


def install_action(args):
    version = args.version
    package_info = get_package_info(
        version,
        args.platform,
        args.type,
        args.arch,
    )
    filename = download_package(package_info)
    if args.download_only:
        return

    print('Instaling...'.format(version))
    print(filename)


def list_action(args):
    for k in get_versions():
        print(k)


def main():
    parser = argparse.ArgumentParser(
        prog='godotenv',
        description='Godot Version Manager',
        formatter_class=SubcommandHelpFormatter,
        usage='%(prog)s [options] <command>'
    )

    actions_parser = parser.add_subparsers(title='commands')

    list_parser = actions_parser.add_parser(
        'list', help='List available versions'
    )
    list_parser.set_defaults(func=list_action)

    install_parser = actions_parser.add_parser(
        'install', help='Download and install the selected version'
    )
    install_parser.add_argument('version', type=str, help='Install a version')
    install_parser.add_argument(
        '--platform',
        type=str,
        help='Download version for linux, windows, macos, ...'
    )
    install_parser.add_argument(
        '--type', type=str, help='Download version standard or mono'
    )
    install_parser.add_argument(
        '--arch', type=str, help='Download version for architeture 32 or 64'
    )
    install_parser.add_argument(
        '--download-only', help='Download only', action='store_true'
    )
    install_parser.set_defaults(func=install_action)

    parser.set_defaults(func=lambda _: parser.print_help())

    args = parser.parse_args()
    args.func(args)


if __name__ == '__main__':
    main()
