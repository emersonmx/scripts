#!/usr/bin/env python

import os
import re
import json
import requests
from bs4 import BeautifulSoup
from deepmerge import always_merger

GODOT_DOWNLOAD_REPOSITORY = "https://downloads.tuxfamily.org/godotengine/"
BASE_PATTERN = re.compile(
    r'^Godot_v'
    r'(?P<version>(\d+\.?)+)'
    r'[-_]'
    r'(?P<tag>stable)'
    r'[-_]'
    r'(?P<extra>.*)'
    r'.*\.zip$'
)
EXTRA_PATTERN = re.compile(
    r'(?P<type>x11|linux_server|osx|win|linux_headless)'
    r'\.?'
    r'(?P<arch>32|64).*'
)


def make_url(version, filename):
    return os.path.join(
        os.path.join(GODOT_DOWNLOAD_REPOSITORY, version), filename
    )


def get_package_info(filename):
    base_match = BASE_PATTERN.match(filename)
    if not base_match:
        return None

    version, tag, extra = base_match.group('version', 'tag', 'extra')
    version_name = '{}-{}'.format(version, tag)

    extra_match = EXTRA_PATTERN.search(extra)
    if not extra_match:
        return None

    mappings = {
        'x11': 'linux',
        'linux_server': 'server',
        'osx': 'osx',
        'win': 'windows',
        'linux_headless': 'headless',
    }
    server_type, arch = extra_match.group('type', 'arch')
    type = 'standard'
    return {
        'version': version_name,
        'platform': mappings[server_type],
        'type': type,
        'arch': arch,
        'url': make_url(version, filename)
    }


def make_package(info):
    return {
        info['platform']: {
            info['type']: {
                info['arch']: {
                    'url': info['url'],
                    'checksum': ''
                }
            }
        }
    }


def get_packages(version):
    page = requests.get(os.path.join(GODOT_DOWNLOAD_REPOSITORY, version))
    soup = BeautifulSoup(page.content, 'html.parser')

    versions = {}
    for anchor in soup.find_all('a'):
        filename = (anchor.contents[0] if anchor.contents else '').strip()
        package_info = get_package_info(filename)
        if package_info:
            package_info = get_package_info(filename)

            versions = always_merger.merge(
                versions, {
                    package_info['version']: make_package(package_info)
                }
            )
            print(
                'version: {version}, '
                'platform: {platform}, '
                'type: {type}, '
                'arch: {arch}'.format(**package_info)
            )

    return versions


def main():
    page = requests.get(GODOT_DOWNLOAD_REPOSITORY)
    soup = BeautifulSoup(page.content, 'html.parser')
    pattern = re.compile(r'^(\d\.?)+$')
    versions = {}
    for anchor in soup.find_all('a'):
        version = (anchor.contents[0] if anchor.contents else '').strip()
        if pattern.match(version):
            print('Fetching packages of version {} ...'.format(version))
            versions = always_merger.merge(versions, get_packages(version))
            print('Done.')

    with open('packages.json', 'w+') as f:
        f.write(json.dumps(versions, indent=4))


if __name__ == '__main__':
    main()
