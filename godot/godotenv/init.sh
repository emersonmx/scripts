script_dir="$(cd "$(dirname "$0")" && pwd)"
godotenv_script=$script_dir/godotenv.py

function godotenv() {
    if [[ $1 = 'install' ]]
    then
        output=$($godotenv_script $*)
        for v in $(echo $output | tail -n2)
        do
            eval "export $v"
        done
    else
        $godotenv_script $*
    fi
}
