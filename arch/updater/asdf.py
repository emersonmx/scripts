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
    env["PATH"] = env["PATH"].replace(f"{env['HOME_LOCAL']}/bin:", "")
    env["PATH"] = env["PATH"].replace(f"{env['ASDF_DATA_DIR']}/shims:", "")

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

    return 0


def get_languages() -> list[str]:
    return [
        "golang",
        # "java",
        # "kotlin",
        "lua",
        "nodejs",
        "python",
        "rust",
    ]


@cache
def get_packages() -> dict[str, list[str]]:
    packages = {}
    files = (
        p for p in Path(f"{HOMEDIR}/.config/asdf/packages").iterdir() if p.is_file()
    )
    for file in files:
        with file.open() as f:
            packages[file.name] = f.read().splitlines()
    return packages


@cache
def get_packages_from_file(filename: str) -> list[str]:
    packages = get_packages()
    return packages.get(filename, [])


def asdf(*args: str) -> None:
    run(["asdf", *args], check=False)


def latest_version(name: str, version: str = LATEST_TAG) -> str:
    version = "" if version == LATEST_TAG else version
    return (
        run(  # type: ignore
            ["asdf", "latest", name, version],
            capture_output=True,
        )
        .stdout.decode()
        .strip()
    )


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
    install_tool("golang")

    packages: list = get_packages_from_file("golang")
    for package in packages:
        asdf("exec", "go", "install", package)

    reshim_tool("golang")


def update_lua() -> None:
    add_plugin("lua")
    versions = ["5.1", LATEST_TAG]
    for v in versions:
        version = latest_version("lua", v)
        install_tool("lua", version)

        for package in get_packages_from_file("lua"):
            asdf("exec", "luarocks", "install", package)

    reshim_tool("lua")


def update_nodejs() -> None:
    env["ASDF_NPM_DEFAULT_PACKAGES_FILE"] = devnull
    add_plugin("nodejs")

    version = latest_version("nodejs", "22")
    install_tool("nodejs", version)

    packages = get_packages_from_file("nodejs")
    if packages:
        asdf("exec", "npm", "install", "-g", *packages)

    reshim_tool("nodejs", version)


def update_python() -> None:
    env["ASDF_PYTHON_DEFAULT_PACKAGES_FILE"] = devnull
    add_plugin("python")

    versions = ["3.12", "3.13"]
    for v in versions:
        version = latest_version("python", v).rstrip("t")
        install_tool("python", version)

        asdf("exec", "python", "-m", "pip", "install", "--upgrade", "pip")
        packages = get_packages_from_file("python")
        if packages:
            asdf("exec", "python", "-m", "pip", "install", "--upgrade", *packages)

    reshim_tool("python")


def update_rust() -> None:
    env["ASDF_CRATE_DEFAULT_PACKAGES_FILE"] = devnull
    add_plugin("rust")

    version = latest_version("rust")
    install_tool("rust", version)

    targets = get_packages_from_file("rustup")
    asdf("exec", "rustup", "target", "install", *targets)

    asdf("exec", "cargo", "install", "cargo-binstall")

    packages = get_packages_from_file("rust")
    run(["asdf", "exec", "cargo", "binstall", *packages], input=b"yes")

    asdf("exec", "cargo", "install-update", "--all")
    reshim_tool("rust")


def update_java() -> None:
    version = "temurin-21.0.6+7.0.LTS"
    add_plugin("java")
    install_tool("java", version)


def update_kotlin() -> None:
    add_plugin("kotlin")
    install_tool("kotlin")


if __name__ == "__main__":
    raise SystemExit(main())
