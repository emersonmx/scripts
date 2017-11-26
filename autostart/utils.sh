is_running() {
    [ "$1" = "" ] && return 0
    [ $(pgrep -f -c "$1") -gt 0 ] && return 1 || return 0
}

function wait_for()
{
    pname=$1
    while [ 1 ]
    do
        is_running $pname
        if [ "$?" -eq 1 ]; then
            break
        fi
        sleep 1
    done
}
