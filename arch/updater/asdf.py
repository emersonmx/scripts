#!/usr/bin/env python

import argparse
import subprocess
from functools import cache, partial
from os import environ as env
from os.path import devnull
from pathlib import Path

run = partial(subprocess.run, check=True)

HOMEDIR = env["HOME"]
LATEST_TAG = "latest"


def main() -> int:
    env["PATH"] = env["PATH"].replace(f'{env["HOME_LOCAL"]}/bin:', "")

    languages = get_languages()

    parser = argparse.ArgumentParser(description="asdf updater")
    parser.add_argument(
        "-l",
        "--languages",
        nargs="+",
        choices=languages,
        default=languages,
    )
    args = parser.parse_args()

    g = globals()
    for language in args.languages:
        update_cmd = g.get(f"update_{language}", lambda: None)
        update_cmd()

    return 0


@cache
def get_languages() -> list[str]:
    return ["asdf"] + [p for p in get_packages().keys()]


@cache
def get_packages() -> dict[str, list[str]]:
    packages = {}
    languages = (
        p for p in Path(f"{HOMEDIR}/.config/asdf/packages").iterdir() if p.is_file()
    )
    for language_path in languages:
        language = language_path.name
        with language_path.open() as f:
            packages[language] = f.read().splitlines()
    return packages


@cache
def get_packages_by_language(language: str) -> list[str]:
    packages = get_packages()
    return packages[language]


def asdf(cmd: str, *args: str) -> None:
    run(["asdf", cmd, *args])


def install_tool(name: str, version: str = LATEST_TAG) -> None:
    asdf("install", name, version)
    make_tool_global(name, version)
    reshim_tool(name, version)


def make_tool_global(name: str, version: str = LATEST_TAG) -> None:
    asdf("global", name, version, "system")


def reshim_tool(name: str, version: str = LATEST_TAG) -> None:
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

    reshim_tool("golang")


def update_lua() -> None:
    install_tool("lua")

    for *opts, package in get_packages_by_language("lua"):  # type: ignore
        run(["luarocks", "install", *opts, package])

    reshim_tool("lua")


def update_nodejs() -> None:
    env["ASDF_NPM_DEFAULT_PACKAGES_FILE"] = devnull
    install_tool("nodejs")

    packages = get_packages_by_language("nodejs")
    if packages:
        run(["npm", "install", "-g", *packages])
    run(["npm", "update", "-g"])

    reshim_tool("nodejs")


def update_python() -> None:
    env["ASDF_PYTHON_DEFAULT_PACKAGES_FILE"] = devnull
    install_tool("python")

    run(["python", "-m", "pip", "install", "--upgrade", "pip"])
    packages = get_packages_by_language("python")
    if packages:
        run(["python", "-m", "pip", "install", "--upgrade", *packages])

    reshim_tool("python")


def update_rust() -> None:
    env["ASDF_CRATE_DEFAULT_PACKAGES_FILE"] = devnull
    install_tool("rust")

    run(["cargo", "install", "cargo-binstall"])
    reshim_tool("rust")

    packages = get_packages_by_language("rust")
    run(["cargo", "binstall", *packages], input=b"yes")
    reshim_tool("rust")

    run(["cargo", "install-update", "-a"])
    reshim_tool("rust")


if __name__ == "__main__":
    raise SystemExit(main())
