import sys

import requests

URL = "https://www.toptal.com/developers/gitignore/api"


def get_languages() -> set[str]:
    data = requests.get(f"{URL}/list")
    result = []
    for line in data.text.splitlines():
        result += [language.strip() for language in line.split(",")]
    return set(result)


def get_gitignore(languages: list[str]) -> str:
    data = requests.get(f"{URL}/{','.join(languages)}")
    return data.text


def main() -> int:
    available_languages = get_languages()
    args = sys.argv

    if len(sys.argv) == 1:
        print(f"Available languages: {sorted(available_languages)}")
        return 1

    input_languages = set(args[1:])
    languages = input_languages & available_languages
    if not languages:
        print(f"{input_languages} languages are invalid.")
        return 1

    print(get_gitignore(list(languages)), end="")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
