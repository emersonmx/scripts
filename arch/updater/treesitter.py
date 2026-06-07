#!/usr/bin/env python

import os
from dataclasses import dataclass, field
from pathlib import Path
import subprocess
import tempfile


@dataclass
class Language:
    name: str
    url: str | None = None
    location: Path | None = None
    revision: str | None = None
    requires: list[str] = field(default_factory=list)


tmp_directory = Path(tempfile.mkdtemp())

nvim_config_directory = Path.home() / ".config" / "nvim"
parser_directory = nvim_config_directory / "parser"
queries_directory = nvim_config_directory / "queries"

tree_sitter_manager_url = "https://github.com/romus204/tree-sitter-manager.nvim"
tree_sitter_manager_directory = tmp_directory / "tree-sitter-manager"
tree_sitter_manager_queries_directory = (
    tree_sitter_manager_directory / "runtime" / "queries"
)

languages: list[Language] = [
    Language(name="bash", url="https://github.com/tree-sitter/tree-sitter-bash"),
    Language(name="c", url="https://github.com/tree-sitter/tree-sitter-c"),
    Language(name="css", url="https://github.com/tree-sitter/tree-sitter-css"),
    Language(
        name="dockerfile", url="https://github.com/camdencheek/tree-sitter-dockerfile"
    ),
    Language(name="gitcommit", url="https://github.com/gbprod/tree-sitter-gitcommit"),
    Language(
        name="gitignore", url="https://github.com/shunsambongi/tree-sitter-gitignore"
    ),
    Language(name="go", url="https://github.com/tree-sitter/tree-sitter-go"),
    Language(name="gotmpl", url="https://github.com/ngalaiko/tree-sitter-go-template"),
    Language(
        name="helm",
        url="https://github.com/ngalaiko/tree-sitter-go-template",
        location=Path("dialects/helm"),
    ),
    Language(
        name="html",
        url="https://github.com/tree-sitter/tree-sitter-html",
        requires=["html_tags"],
    ),
    Language(name="html_tags"),
    Language(
        name="javascript",
        url="https://github.com/tree-sitter/tree-sitter-javascript",
        requires=["ecma", "jsx"],
    ),
    Language(name="ecma"),
    Language(name="jsx"),
    Language(name="json", url="https://github.com/tree-sitter/tree-sitter-json"),
    Language(name="lua", url="https://github.com/tree-sitter-grammars/tree-sitter-lua"),
    Language(
        name="make", url="https://github.com/tree-sitter-grammars/tree-sitter-make"
    ),
    Language(
        name="markdown",
        url="https://github.com/tree-sitter-grammars/tree-sitter-markdown",
        location=Path("tree-sitter-markdown"),
        requires=["markdown_inline"],
    ),
    Language(
        name="markdown_inline",
        url="https://github.com/tree-sitter-grammars/tree-sitter-markdown",
        location=Path("tree-sitter-markdown-inline"),
    ),
    Language(
        name="python",
        url="https://github.com/tree-sitter/tree-sitter-python",
        revision="v0.25.0",
    ),
    Language(name="rust", url="https://github.com/tree-sitter/tree-sitter-rust"),
    Language(
        name="toml", url="https://github.com/tree-sitter-grammars/tree-sitter-toml"
    ),
    Language(
        name="typescript",
        url="https://github.com/tree-sitter/tree-sitter-typescript",
        location=Path("typescript"),
        requires=["ecma"],
    ),
    Language(name="vim", url="https://github.com/tree-sitter-grammars/tree-sitter-vim"),
    Language(name="vimdoc", url="https://github.com/neovim/tree-sitter-vimdoc"),
    Language(
        name="yaml", url="https://github.com/tree-sitter-grammars/tree-sitter-yaml"
    ),
]


def clone_repo(url: str, directory: Path, revision: str | None) -> None:
    base_cmd = ["git", "clone", "--depth", "1"]
    if revision:
        base_cmd += ["--revision", revision]
    subprocess.run([*base_cmd, url, directory], check=True)


def build_parser(repo_directory: Path, output_path: Path) -> None:
    subprocess.run(
        ["tree-sitter", "build", "-o", output_path],
        cwd=repo_directory,
        check=True,
    )


def copy_queries(source_directory: Path, destination_directory: Path) -> None:
    for file in source_directory.iterdir():
        if file.is_file() and file.suffix == ".scm":
            destination_file = destination_directory / file.name
            destination_file.parent.mkdir(parents=True, exist_ok=True)
            destination_file.write_bytes(file.read_bytes())


def main() -> int:
    print("Updating tree-sitter parsers...")

    parser_directory.mkdir(parents=True, exist_ok=True)
    queries_directory.mkdir(parents=True, exist_ok=True)
    clone_repo(tree_sitter_manager_url, tree_sitter_manager_directory, None)

    for language in languages:
        name = language.name

        query_source_path = tree_sitter_manager_queries_directory / name
        if query_source_path.is_dir():
            query_destination_path = queries_directory / name
            copy_queries(query_source_path, query_destination_path)

        url = language.url
        if url is None:
            continue

        repo_directory = tmp_directory / name
        repo_directory.mkdir(parents=True, exist_ok=True)
        location = repo_directory
        if language.location is not None:
            location = repo_directory / language.location

        revision = language.revision

        print(f"Updating {name}...")
        clone_repo(url, repo_directory, revision)
        output_path = parser_directory / f"{name}.so"
        build_parser(location, output_path)

    print("Done.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
