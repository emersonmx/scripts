#!/usr/bin/env python

# flake8: noqa: T001

import tempfile
from pathlib import Path
from subprocess import run

HOMEDIR = Path.home()
USER_LOCAL = HOMEDIR / ".local"
USER_LOCAL_BIN = USER_LOCAL / "bin"


def main() -> int:
    update_godot_editor()

    return 0


def update_godot_editor() -> None:
    print("Installing Godot Editor...")

    repo_url = "https://github.com/godotengine/godot"
    version = (
        run(
            " | ".join(
                [
                    f"git ls-remote --tags --refs '{repo_url}'",
                    "grep -o 'refs/tags/.*'",
                    "cut -d/ -f3-",
                    "sed 's/^v//'",
                    "tail -n1",
                ]
            ),
            shell=True,
            capture_output=True,
        )
        .stdout.decode()
        .strip()
    )

    platform = "x11.64"
    filename = f"Godot_v{version}_{platform}"
    url = f"{repo_url}/releases/download/{version}/{filename}.zip"
    desktop_file_url = "https://raw.githubusercontent.com/godotengine/godot/master/misc/dist/linux/org.godotengine.Godot.desktop"
    shortcuts_dir = USER_LOCAL / "share" / "applications"

    godot_path = USER_LOCAL_BIN / "godot"
    with tempfile.TemporaryDirectory() as f:
        godot_tmp_dir = Path(f)
        godot_tmp_file = godot_tmp_dir / "godot.zip"
        run(["curl", "-fSL", "-o", godot_tmp_file, "-C", "-", url])
        run(["unzip", godot_tmp_file, "-d", godot_tmp_dir])
        run(["rm", godot_tmp_file])
        run(["install", "-Dm775", godot_tmp_dir / filename, godot_path])

    run(
        [
            "curl",
            "-fSL",
            "--create-dirs",
            "-O",
            "--output-dir",
            shortcuts_dir,
            desktop_file_url,
        ]
    )

    print("Done.\n")


if __name__ == "__main__":
    raise SystemExit(main())