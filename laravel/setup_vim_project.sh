#!/bin/bash

EDITOR_CONFIG="$HOME/.vim/vimrc"
if [[ $EDITOR == 'nvim' ]]
then
    EDITOR_CONFIG="$HOME/.config/nvim/init.vim"
fi

function reset_file()
{
    rm -f "$1"
    touch "$filename"
}

function make_snippet()
{
    filename="$1"
    snippet="$2"

    echo "Creating $filename"
    reset_file $filename
    $EDITOR -u $EDITOR_CONFIG -es $filename <<-SCRIPT
execute "normal! \<esc>a$snippet\<c-r>=UltiSnips#ExpandSnippet()\<cr>\<esc>:w\<cr>"
SCRIPT
    echo "Done."
}

function make_phpactor_config()
{
    filename=".phpactor.json"

    echo "Creating $filename"
    reset_file $filename
    echo "{}" > $filename
    $EDITOR -u $EDITOR_CONFIG -es $filename <<-SCRIPT
execute "normal! \<esc>:set ft=php\<cr>:call phpactor#Config()\<cr>:wincmd w\<cr>ggVGy\<esc>:wincmd w\<cr>ggVGp\<esc>:w\<cr>"
SCRIPT
    echo "Done."
}

make_snippet .gutctags phptempl
make_phpactor_config
make_snippet .projections.json laraveltempl
make_snippet .shenv laraveltempl
make_snippet .vimproject phptempl
make_snippet .php_cs.dist defaulttempl
