import json
import pathlib
from subprocess import run


def main() -> None:
    vim_path = pathlib.Path(".vim")
    vim_path.mkdir(exist_ok=True)
    coc_settings_path = vim_path / "coc-settings.json"
    if not coc_settings_path.exists():
        python_binary_path = (
            run(["poetry", "run", "which", "python"], capture_output=True)
            .stdout.decode()
            .strip()
        )
        coc_settings = {"python.pythonPath": python_binary_path}
        with open(".vim/coc-settings.json", "w+") as f:
            json.dump(coc_settings, f, indent=4)


if __name__ == "__main__":
    main()
