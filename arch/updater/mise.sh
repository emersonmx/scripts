#!/usr/bin/env bash
# shellcheck disable=SC2086

CONFIG_PATH="$HOME/.config/mise"
COMPLETIONS_PATH="$HOME/.cache/zsh/completions"

function main() {
    setup
    if [[ $# -eq 0 ]]; then
        update_tools
    else
        for language in "$@"; do
            "update_$language"
        done
    fi

    reshim

    echo ""
    echo "Installed versions:"
    mise list
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
    else
        exit 1
    fi
}

function valid_semver() {
    grep -P '^\d+(\.\d+)*$' | sort -V
}

function get_latest_version() {
    tool="$1"
    version="@${2:-latest}"
    filter_fn="$3"

    if [[ $version == "@latest" ]]; then
        echo "latest"
        exit 0
    fi

    if [[ $filter_fn ]]; then
        mise ls-remote "$tool$version" | "$filter_fn" | tail -n1
    else
        mise ls-remote "$tool$version" | tail -n1
    fi
}

function install_tool() {
    mise use --global $1
}

function setup() {
    mkdir -p "$COMPLETIONS_PATH"
}

function update_tools() {
    for language in $(get_languages); do
        "update_$language"
    done
}

function reshim() {
    mise reshim
}

function update_golang() {
    language="golang"
    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language $version)
        tool="$language@$latest_version"
        install_tool "$tool"

        for package in $(get_packages $language); do
            mise exec "$tool" -- go install "$package"
        done
    done
}

function update_java() {
    language="java"
    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language $version)
        tool="$language@$latest_version"
        install_tool "$tool"
    done
}

function update_kotlin() {
    language="kotlin"
    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language $version valid_semver)
        tool="$language@$latest_version"
        install_tool "$tool"
    done
}

function update_lua() {
    language="lua"
    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language $version)
        tool="$language@$latest_version"
        install_tool "$tool"

        for package in $(get_packages $language); do
            mise exec "$tool" -- luarocks install "$package"
        done
    done
}

function update_nodejs() {
    language="nodejs"
    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language $version)
        tool="$language@$latest_version"
        install_tool "$tool"

        packages=$(get_packages $language)
        if [[ $packages ]]; then
            mise exec "$tool" -- npm install -g $packages
        fi
    done
}

function update_python() {
    language="python"
    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language $version valid_semver)
        tool="$language@$latest_version"
        install_tool "$tool"

        mise exec "$tool" -- python -m pip install --upgrade pip
        packages=$(get_packages $language)
        if [[ $packages ]]; then
            mise exec "$tool" -- python -m pip install --upgrade $packages
        fi

        mise exec "$tool" -- uv generate-shell-completion zsh >"$COMPLETIONS_PATH/_uv"
    done
}

function update_rust() {
    language="rust"
    for version in $(get_tool_versions $language); do
        latest_version=$(get_latest_version $language $version)
        tool="$language@$latest_version"
        install_tool "$tool"

        targets=$(get_packages "rustup")
        if [[ $targets ]]; then
            mise exec "$tool" -- rustup target install $targets
        fi

        for package in $(get_packages 'rust-install'); do
            use_git=$(echo $package | grep -E '^https://')
            if [[ $use_git ]]; then
                mise exec "$tool" -- cargo install --locked --git "$package"
            else
                mise exec "$tool" -- cargo install --locked "$package"
            fi
        done

        packages=$(get_packages "rust-binstall")
        if [[ $packages ]]; then
            mise exec "$tool" -- cargo binstall -y $packages
        fi

        mise exec "$tool" -- cargo install-update --all --git

        mise exec "$tool" -- rustup completions zsh >"$COMPLETIONS_PATH/_rustup"
        mise exec "$tool" -- just --completions zsh >"$COMPLETIONS_PATH/_just"
        mise exec "$tool" -- kache completions zsh >"$COMPLETIONS_PATH/_kache"
        mise exec "$tool" -- droast completion zsh >"$COMPLETIONS_PATH/_droast"
        mise exec "$tool" -- tp completions zsh >"$COMPLETIONS_PATH/_tp"
    done
}

function update_usage() {
    install_tool usage
}

main "$@"
