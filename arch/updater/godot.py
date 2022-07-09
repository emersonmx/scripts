#!/usr/bin/env python

# flake8: noqa: T001

import subprocess
import tempfile
from functools import cache, partial
from pathlib import Path

HOMEDIR = Path.home()
USER_LOCAL = HOMEDIR / ".local"
USER_LOCAL_BIN = USER_LOCAL / "bin"
REPOSITORY_URL = "https://github.com/godotengine/godot"
SHORTCUTS_DIR = USER_LOCAL / "share" / "applications"

run = partial(subprocess.run, check=True)


def main() -> int:
    update_godot_editor()
    update_godot_headless()
    return 0


def update_godot_editor() -> None:
    print("Installing Godot Editor...")

    install_package("godot", "x11.64")

    desktop_file_url = "https://raw.githubusercontent.com/godotengine/godot/master/misc/dist/linux/org.godotengine.Godot.desktop"
    run(
        [
            "curl",
            "-fSL",
            "--create-dirs",
            "-O",
            "--output-dir",
            SHORTCUTS_DIR,
            desktop_file_url,
        ]
    )

    print("Done.\n")


def get_download_url(platform: str) -> str:
    version = get_latest_version()
    filename = get_download_filename(platform)
    return f"{REPOSITORY_URL}/releases/download/{version}/{filename}.zip"


@cache
def get_latest_version() -> str:
    return (
        run(
            " | ".join(
                [
                    f"git ls-remote --tags --refs '{REPOSITORY_URL}'",
                    "grep -o 'refs/tags/.*'",
                    "cut -d/ -f3-",
                    "sed 's/^v//'",
                    "tail -n1",
                ]
            ),
            shell=True,
            capture_output=True,
        )
        .stdout.decode()  # type: ignore
        .strip()
    )


def get_download_filename(platform: str) -> str:
    version = get_latest_version()
    return f"Godot_v{version}_{platform}"


def install_package(binary_name: str, platform: str) -> None:
    url = get_download_url(platform)
    filename = get_download_filename(platform)
    binary_path = USER_LOCAL_BIN / binary_name
    with tempfile.TemporaryDirectory() as f:
        tmp_dir = Path(f)
        tmp_file = tmp_dir / "package.zip"
        run(["curl", "-fSL", "-o", tmp_file, "-C", "-", url])
        run(["unzip", tmp_file, "-d", tmp_dir])
        run(["rm", tmp_file])
        run(["install", "-Dm775", tmp_dir / filename, binary_path])


def update_godot_headless() -> None:
    print("Installing Godot Headless...")
    install_package("godot_headless", "linux_headless.64")
    print("Done.\n")


if __name__ == "__main__":
    raise SystemExit(main())
