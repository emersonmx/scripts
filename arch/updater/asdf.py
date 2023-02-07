#!/usr/bin/env python

import argparse
import json
import re
import subprocess
from functools import cache, partial
from os import environ as env
from os.path import devnull

run = partial(subprocess.run, check=True)

HOMEDIR = env["HOME"]


def main() -> int:
    env["PATH"] = env["PATH"].replace(f'{env["HOME_LOCAL"]}/bin:', "")

    languages = get_languages()

    parser = argparse.ArgumentParser(description="asdf updater")
    parser.add_argument("-l", "--languages", nargs="+", choices=languages)
    args = parser.parse_args()

    g = globals()
    for language in args.languages or languages:
        update_cmd = g.get(f"update_{language}", lambda: None)
        update_cmd()

    return 0


@cache
def get_languages() -> list[str]:
    return ["asdf"] + [p for p in get_packages().keys()]


@cache
def get_packages() -> dict:
    with open(f"{HOMEDIR}/.config/asdf/default-packages.json") as f:
        return json.load(f)


@cache
def get_packages_by_language(language: str) -> list[str] | list[list[str]]:
    packages = get_packages()
    return packages[language]


@cache
def get_language_versions(language: str) -> list[str]:
    version_pattern = re.compile(r"^\d+(\.\d+)*$")
    output = run(
        ["asdf", "list", "all", language],
        capture_output=True,
    ).stdout.decode()  # type: ignore
    versions = []
    for line in output.splitlines():
        if version_pattern.match(line):
            raw_version = [int(e) for e in line.split(".")]
            padded_version = [0] * 3
            version = tuple(raw_version + padded_version)[:3]
            original_version = line
            versions.append((version, original_version))

    return [version for _, version in sorted(versions, key=lambda i: i[0])]


@cache
def get_latest_version_by_language(language: str) -> str:
    version = get_language_versions(language)
    return version[-1]


def asdf(cmd: str, *args: str) -> None:
    run(["asdf", cmd, *args])


def install_tool(name: str, version: str = "latest") -> None:
    if version == "latest":
        version = get_latest_version_by_language(name)

    asdf("install", name, version)
    asdf("global", name, version, "system")
    asdf("reshim", name, version)


def update_asdf() -> None:
    asdf("update")
    asdf("plugin", "update", "--all")


def update_golang() -> None:
    env["ASDF_GOLANG_DEFAULT_PACKAGES_FILE"] = devnull
    install_tool("golang")

    packages: list = get_packages_by_language("golang")
    for package in packages:
        run(["go", "install", package])

    asdf("reshim", "golang")


def update_lua() -> None:
    install_tool("lua")

    for *opts, package in get_packages_by_language("lua"):  # type: ignore
        run(["luarocks", "install", *opts, package])

    asdf("reshim", "lua")


def update_nodejs() -> None:
    env["ASDF_NPM_DEFAULT_PACKAGES_FILE"] = devnull
    install_tool("nodejs")

    packages = get_packages_by_language("nodejs")
    if packages:
        run(["npm", "install", "-g", *packages])
    run(["npm", "update", "-g"])

    asdf("reshim", "nodejs")


def update_python() -> None:
    env["ASDF_PYTHON_DEFAULT_PACKAGES_FILE"] = devnull
    install_tool("python")

    packages = get_packages_by_language("python")
    run(["python", "-m", "pip", "install", "--upgrade", "pip"])
    run(["python", "-m", "pip", "install", "--upgrade", *packages])

    asdf("reshim", "python")


def update_rust() -> None:
    env["ASDF_CRATE_DEFAULT_PACKAGES_FILE"] = devnull
    install_tool("rust")

    packages = get_packages_by_language("rust")
    run(["cargo", "install", "-f", *packages])

    asdf("reshim", "rust")


if __name__ == "__main__":
    raise SystemExit(main())
