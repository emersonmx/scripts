#!/bin/bash

function wait_for()
{
    pname=$1
    until pids=$(pidof $pname)
    do
        sleep 1
    done
}

wait_for tmux
wait_for chromium

tmux run 'tmuxinator jupyter'
