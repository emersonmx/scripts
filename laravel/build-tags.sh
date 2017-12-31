#!/bin/bash

tags_path=.tags/

function ctags_exec() {
    ctags --tag-relative=never --fields=+aimlS --languages=php $*
}

mkdir -p .tags/

echo 'Creating tags...'
ctags_exec -f _ide_helper.tags _ide_helper.php
ctags_exec --exclude=vendor/composer/ -f vendor.tags -R vendor/

[ -f _ide_helper.tags ] && mv -f _ide_helper.tags $tags_path
[ -f vendor.tags ] && mv -f vendor.tags $tags_path

echo 'Done.'
