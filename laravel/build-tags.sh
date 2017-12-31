#!/bin/bash

tags_path=.tags/

function ctags_exec() {
    ctags --tag-relative=never --fields=+aimlS --languages=php $*
}

function show_usage() {
    echo "Usage: $(basename $0) <all|vendor|ide-helper|app>"
}

function build_all() {
    build_vendor
    build_ide_helper
    build_app
}

function build_vendor() {
    echo 'Building vendor tags...'
    ctags_exec --exclude=vendor/composer -f vendor.tags -R vendor/
    [ -f vendor.tags ] && mv -f vendor.tags $tags_path
    echo 'Done.'
}

function build_ide_helper() {
    echo 'Building ide helper tags...'
    ctags_exec -f _ide_helper.tags _ide_helper.php
    [ -f _ide_helper.tags ] && mv -f _ide_helper.tags $tags_path
    echo 'Done.'
}

function build_app() {
    echo 'Building app tags...'
    ctags_exec --exclude=vendor --exclude=_ide_helper.php -f app.tags -R .
    [ -f app.tags ] && mv -f app.tags $tags_path
    echo 'Done.'
}

function handle_action() {
    case $1 in
        all )
            build_all
            ;;
        vendor )
            build_vendor
            ;;
        ide-helper )
            build_ide_helper
            ;;
        app )
            build_app
            ;;
        * )
            show_usage
            ;;
    esac
}

if [[ $# != 1 ]]; then
    show_usage
    exit 0
fi

if [[ ! -d $tags_path ]]
then
    echo "Creating $tags_path directory"
    mkdir -p $tags_path
fi

handle_action $1
