#!/usr/bin/env python

import json
from functools import cache
from os import environ as env
from os.path import devnull
from subprocess import run

HOMEDIR = env["HOME"]


def main() -> int:
    env["PATH"] = env["PATH"].replace(f'{env["USER_LOCAL"]}/bin:', "")
    env.update(
        {
            "CMAKE_C_COMPILER_LAUNCHER": "sccache",
            "CMAKE_CXX_COMPILER_LAUNCHER": "sccache",
        }
    )

    update_asdf()
    update_golang()
    update_lua()
    update_nodejs()
    update_python()
    update_rust()
    update_misc_tools()

    return 0


@cache
def get_packages() -> dict:
    with open(f"{HOMEDIR}/.config/asdf/default-packages.json") as f:
        return json.load(f)


@cache
def get_packages_by_language(language: str) -> list[str] | list[list[str]]:
    packages = get_packages()
    return packages[language]


def asdf(cmd: str, *args: str) -> None:
    run(["asdf", cmd, *args])


def install_tool(name: str, version: str = "latest") -> None:
    asdf("install", name, version)
    asdf("global", name, version)
    asdf("reshim", name, version)


def update_asdf() -> None:
    asdf("update")
    asdf("plugin", "update", "--all")


def update_golang() -> None:
    env["ASDF_GOLANG_DEFAULT_PACKAGES_FILE"] = devnull
    install_tool("golang")

    packages = get_packages_by_language("golang")
    run(["go", "install", *packages])

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


def update_misc_tools() -> None:
    tools = [
        "direnv",
        "k3d",
        "kubectl",
    ]
    for tool in tools:
        install_tool(tool)


if __name__ == "__main__":
    raise SystemExit(main())
