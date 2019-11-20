#!/usr/bin/env python

import sys
import json
import shutil
import subprocess


def command_exists(cmd):
    return shutil.which(cmd)


def run_install_packages(install_command, packages):
    with subprocess.Popen([*install_command, *packages]) as _:
        print("{} {}".format(
            ' '.join(install_command), ' '.join(packages)))


def run_manual_install(command):
    with subprocess.Popen(command, shell=True) as _:
        print(command)


def process_configs(configs):
    for pkgname, data in configs.items():
        package_list = []
        install_command = data.get('install-command', None)
        if install_command:
            for p in data['packages']:
                cmd, pkg = None, None
                if isinstance(p, str):
                    cmd, pkg = p, p
                else:
                    cmd, pkg = p['command'], p['package_name']

                assert cmd and pkg

                if command_exists(cmd):
                    continue

                package_list.append(pkg)

            if not package_list:
                continue

            run_install_packages(install_command, package_list)
        else:
            for p in data['packages']:
                cmd, install_command = p['command'], p['install-command']

                if command_exists(cmd):
                    continue

                run_manual_install(install_command)


def main():
    packages_config = sys.argv[1] if len(sys.argv) > 1 else 'packages.json'

    configs = {}
    with open(packages_config) as j:
        configs = json.load(j)

    process_configs(configs)


if __name__ == '__main__':
    main()
