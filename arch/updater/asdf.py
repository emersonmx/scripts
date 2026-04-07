#!/usr/bin/env python

import argparse
import subprocess
import os
import re
from functools import cache, partial
from os import environ as env
from os.path import devnull
from pathlib import Path
from typing import Callable

run = partial(subprocess.run, check=True)

OLD_PATH = env["PATH"]
HOMEDIR = env["HOME"]
LATEST_TAG = "latest"
COMPLETIONS_PATH = Path(HOMEDIR) / ".cache" / "zsh" / "completions"
VERSION_PATTERN = re.compile(r"^\d+(\.\d+)*$")


def main() -> int:
    setup()

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

    asdf("reshim")

    print()
    print("Installed versions:")
    asdf("list")

    return 0


def setup() -> None:
    env["PATH"] = env["PATH"].replace(f"{env['HOME_LOCAL']}/bin:", "")
    env["PATH"] = env["PATH"].replace(f"{env['ASDF_DATA_DIR']}/shims:", "")

    os.makedirs(COMPLETIONS_PATH, exist_ok=True)


@cache
def get_tools() -> dict[str, list[str]]:
    tools = {}
    with Path(f"{HOMEDIR}/.config/asdf/tools").open() as f:
        for line in f.read().splitlines():
            tool, *versions = line.split(" ")
            if versions:
                tools[tool] = versions
    return tools


def get_languages() -> list[str]:
    return list(get_tools())


def get_tool_versions(tool: str) -> list[str]:
    tools = get_tools()
    return tools.get(tool, [])


@cache
def get_packages() -> dict[str, list[str]]:
    packages = {}
    files = (
        p
        for p in Path(f"{HOMEDIR}/.config/asdf").iterdir()
        if p.is_file() and p.name != "tools"
    )
    for file in files:
        with file.open() as f:
            packages[file.name] = f.read().splitlines()
    return packages


@cache
def get_packages_from_file(filename: str) -> list[str]:
    packages = get_packages()
    return packages.get(filename, [])


def valid_version(version: str) -> bool:
    return bool(VERSION_PATTERN.match(version))


def asdf(*args: str) -> None:
    run(["asdf", *args], check=False)


def latest_version(
    name: str,
    version: str = LATEST_TAG,
    filter_fn: Callable[[str], bool] | None = None,
) -> str:
    version = "" if version == LATEST_TAG else version
    versions = (
        run(  # type: ignore
            ["asdf", "list", "all", name, version],
            capture_output=True,
        )
        .stdout.decode()
        .strip()
    ).splitlines()
    if filter_fn:
        versions = [v for v in versions if filter_fn(v)]
    return versions[-1] if version else LATEST_TAG


def install_tool(name: str, version: str = LATEST_TAG) -> None:
    asdf("install", name, version)
    use_as_default_tool(name, version)


def add_plugin(name: str) -> None:
    asdf("plugin", "add", name)


def use_as_default_tool(name: str, version: str = LATEST_TAG) -> None:
    asdf("set", "--home", name, version, "system")


def reshim_tool(name: str, version: str = LATEST_TAG) -> None:
    asdf("reshim", name, version)


def update_golang() -> None:
    env["ASDF_GOLANG_DEFAULT_PACKAGES_FILE"] = devnull
    add_plugin("golang")

    versions = get_tool_versions("golang")
    for v in versions:
        version = latest_version("golang", v)
        install_tool("golang", version)

        for package in get_packages_from_file("golang"):
            asdf("exec", "go", "install", package)

    reshim_tool("golang")


def update_lua() -> None:
    add_plugin("lua")

    versions = get_tool_versions("lua")
    for v in versions:
        version = latest_version("lua", v)
        install_tool("lua", version)

        for package in get_packages_from_file("lua"):
            asdf("exec", "luarocks", "install", package)

    reshim_tool("lua")


def update_nodejs() -> None:
    clean_path = env["PATH"]
    env["PATH"] = OLD_PATH
    env["ASDF_NPM_DEFAULT_PACKAGES_FILE"] = devnull
    add_plugin("nodejs")

    versions = get_tool_versions("nodejs")
    for v in versions:
        version = latest_version("nodejs", v)
        install_tool("nodejs", version)

        packages = get_packages_from_file("nodejs")
        if packages:
            asdf("exec", "npm", "install", "-g", *packages)

        reshim_tool("nodejs", version)

    env["PATH"] = clean_path


def update_python() -> None:
    env["ASDF_PYTHON_DEFAULT_PACKAGES_FILE"] = devnull
    add_plugin("python")

    versions = get_tool_versions("python")
    for v in versions:
        version = latest_version("python", v, valid_version)
        install_tool("python", version)

        asdf("exec", "python", "-m", "pip", "install", "--upgrade", "pip")
        packages = get_packages_from_file("python")
        if packages:
            asdf("exec", "python", "-m", "pip", "install", "--upgrade", *packages)

    with open(COMPLETIONS_PATH / "_uv", "w") as f:
        run(
            ["asdf", "exec", "uv", "generate-shell-completion", "zsh"],
            check=False,
            stdout=f,
        )

    with open(COMPLETIONS_PATH / "_uvx", "w") as f:
        run(
            ["asdf", "exec", "uvx", "--generate-shell-completion", "zsh"],
            check=False,
            stdout=f,
        )

    reshim_tool("python")


def update_rust() -> None:
    env["ASDF_CRATE_DEFAULT_PACKAGES_FILE"] = devnull
    add_plugin("rust")

    versions = get_tool_versions("rust")
    for v in versions:
        version = latest_version("rust", v)
        install_tool("rust", version)

        targets = get_packages_from_file("rustup")
        asdf("exec", "rustup", "target", "install", *targets)

        for package in get_packages_from_file("rust-install"):
            if package.startswith("https://"):
                asdf("exec", "cargo", "install", "--git", package)
            else:
                asdf("exec", "cargo", "install", package)

        packages = get_packages_from_file("rust-binstall")
        run(["asdf", "exec", "cargo", "binstall", *packages], input=b"yes")

        asdf("exec", "cargo", "install-update", "--all", "--git")

        with open(COMPLETIONS_PATH / "_just", "w") as f:
            run(["asdf", "exec", "just", "--completions", "zsh"], check=False, stdout=f)

    reshim_tool("rust")


def update_java() -> None:
    add_plugin("java")

    versions = get_tool_versions("java")
    for v in versions:
        version = latest_version("java", v)
        install_tool("java", version)


def update_kotlin() -> None:
    add_plugin("kotlin")

    versions = get_tool_versions("kotlin")
    for v in versions:
        version = latest_version("kotlin", v, valid_version)
        install_tool("kotlin", version)


if __name__ == "__main__":
    raise SystemExit(main())
