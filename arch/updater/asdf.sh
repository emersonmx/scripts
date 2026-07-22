#!/usr/bin/env bash

set -euo pipefail

CONFIG_PATH="$HOME/.config/asdf"
COMPLETIONS_PATH="$HOME/.cache/zsh/completions"
OLD_PATH=$PATH

function main() {
    setup

    if [[ $# -eq 0 ]]; then
        mapfile -t languages < <(get_languages)
        update_tools "${languages[@]}"
    else
        update_tools "$@"
    fi

    asdf reshim

    echo ""
    echo "Installed versions:"
    asdf list
}

function get_tools() {
    cat "$CONFIG_PATH/tools"
}

function get_languages() {
    get_tools | cut -d' ' -f1 | sort -u
}

function get_tool_versions() {
    get_tools | grep "^$1" | cut -d' ' -f2-
}

function get_packages() {
    tool="$1"
    filepath="$CONFIG_PATH/$tool"
    if [[ -f "$filepath" ]]; then
        cat "$filepath"
    fi
}

function valid_semver() {
    grep -P '^\d+(\.\d+)*$' | sort -V
}

function get_latest_version() {
    tool="$1"
    version="${2:-latest}"
    filter_fn="${3:-}"

    if [[ $version == "latest" ]]; then
        echo "latest"
        exit 0
    fi

    if [[ $filter_fn ]]; then
        asdf list all "$tool" "$version" | "$filter_fn" | tail -n1
    else
        asdf list all "$tool" "$version" | tail -n1
    fi
}

function install_tool() {
    tool="$1"
    version="${2:-latest}"
    asdf install "$tool" "$version"
    asdf set --home "$tool" "$version" "system"
    asdf reshim "$language"
}

function set_clean_path() {
    PATH=$(echo "$PATH" | sed -e 's#'"$HOME"'/.local/bin:##' -e 's#'"$ASDF_DATA_DIR"'/shims:##')
    export PATH
}

function restore_path() {
    export PATH=$OLD_PATH
}

function setup() {
    set_clean_path

    mkdir -p "$COMPLETIONS_PATH"
}

function update_tools() {
    for language in "$@"; do
        "update_$language"
    done
}

function update_golang() {
    export ASDF_GOLANG_DEFAULT_PACKAGES_FILE=
    language="golang"

    asdf plugin add $language

    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language "$version")
        install_tool $language "$latest_version"

        get_packages $language | xargs -r -n1 asdf exec go install
    done

    asdf reshim $language
}

function update_java() {
    language="java"

    asdf plugin add $language

    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language "$version")
        install_tool $language "$latest_version"
    done

    asdf reshim $language
}

function update_kotlin() {
    language="kotlin"

    asdf plugin add $language

    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language "$version" valid_semver)
        install_tool $language "$latest_version"
    done

    asdf reshim $language
}

function update_lua() {
    language="lua"

    asdf plugin add $language

    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language "$version")
        install_tool $language "$latest_version"

        get_packages $language | xargs -r -n1 asdf exec luarocks install
    done

    asdf reshim $language
}

function update_nodejs() {
    restore_path

    export ASDF_NODEJS_DEFAULT_PACKAGES_FILE=
    language="nodejs"

    asdf plugin add $language

    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language "$version")
        install_tool $language "$latest_version"

        mapfile -t packages < <(get_packages "$language") || true
        if [[ ${#packages[@]} -gt 0 ]]; then
            asdf exec npm install -g "${packages[@]}"
        fi
    done

    asdf reshim $language

    set_clean_path
}

function update_python() {
    export ASDF_PYTHON_DEFAULT_PACKAGES_FILE=
    language="python"

    asdf plugin add $language

    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language "$version" valid_semver)
        install_tool $language "$latest_version"

        asdf exec python -m pip install --upgrade pip

        mapfile -t packages < <(get_packages "$language") || true
        if [[ ${#packages[@]} -gt 0 ]]; then
            asdf exec python -m pip install --upgrade "${packages[@]}"
        fi
    done

    asdf reshim $language

    asdf exec uv generate-shell-completion zsh >"$COMPLETIONS_PATH/_uv"
    asdf exec uvx --generate-shell-completion zsh >"$COMPLETIONS_PATH/_uvx"
}

function update_rust() {
    export ASDF_CRATE_DEFAULT_PACKAGES_FILE=
    language="rust"

    asdf plugin add $language

    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language "$version")
        install_tool $language "$latest_version"

        mapfile -t targets < <(get_packages "rustup") || true
        if [[ ${#targets[@]} -gt 0 ]]; then
            asdf exec rustup target install "${targets[@]}"
        fi

        for package in $(get_packages 'rust-install'); do
            if [[ $package =~ ^https:// ]]; then
                asdf exec cargo install --locked --git "$package"
            else
                asdf exec cargo install --locked "$package"
            fi
        done

        mapfile -t packages < <(get_packages "rust-binstall") || true
        if [[ ${#packages[@]} -gt 0 ]]; then
            asdf exec cargo binstall -y "${packages[@]}"
        fi

        asdf exec cargo install-update --all --git
    done

    asdf reshim $language

    asdf exec rustup completions zsh >"$COMPLETIONS_PATH/_rustup"
    asdf exec just --completions zsh >"$COMPLETIONS_PATH/_just"
    asdf exec kache completions zsh >"$COMPLETIONS_PATH/_kache"
    asdf exec droast completion zsh >"$COMPLETIONS_PATH/_droast"
    asdf exec tp completions zsh >"$COMPLETIONS_PATH/_tp"
}

main "$@"
