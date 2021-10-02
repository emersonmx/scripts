import json
import pathlib
from subprocess import run


def main() -> None:
    vim_path = pathlib.Path(".vim")
    coc_settings_path = vim_path / "coc-settings.json"
    if coc_settings_path.exists():
        print(f"{coc_settings_path} already exists!")
        return

    python_path_cmd = run(
        "poetry run which python",
        capture_output=True,
        shell=True,
    )
    python_path_cmd.check_returncode()

    python_binary_path = python_path_cmd.stdout.decode().strip()
    coc_settings = {"python.pythonPath": python_binary_path}

    vim_path.mkdir(exist_ok=True)
    with open(".vim/coc-settings.json", "w+") as f:
        json.dump(coc_settings, f, indent=4)


if __name__ == "__main__":
    main()
