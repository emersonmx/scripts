#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import json
import shlex
import subprocess
import click

CONFIG_ROOT_PATH = os.path.join(os.path.expandvars('$HOME'), '.config/bgmusic')
CONFIG_PATH = os.path.join(CONFIG_ROOT_PATH, 'config.json')
PLAYLIST_PATH = os.path.join(CONFIG_ROOT_PATH, 'playlist.m3u')
DEFAULT_CONFIG = {
    'player': '/usr/bin/mpv',
    'args': '--volume=40 -vo=null  --save-position-on-quit -shuffle --playlist={playlist}'
}

@click.group()
@click.pass_context
def cli(ctx):
    if not os.path.exists(CONFIG_ROOT_PATH):
        os.mkdir(CONFIG_ROOT_PATH)

    config = DEFAULT_CONFIG
    if os.path.exists(CONFIG_PATH):
        with open(CONFIG_PATH) as f:
            loaded_config = json.load(f)
            config = {**DEFAULT_CONFIG, **loaded_config}

    if not os.path.exists(PLAYLIST_PATH):
        with open(PLAYLIST_PATH, 'a') as f:
            os.utime(PLAYLIST_PATH, None)

    ctx.obj = config

@cli.command()
@click.pass_context
def play(ctx):
    config = ctx.obj
    player = config['player']
    args = shlex.split(config['args'].format(playlist=PLAYLIST_PATH))
    subprocess.run([player, *args])

@cli.command()
@click.argument('music', type=click.Path())
@click.pass_context
def add(ctx, music):
    music_path = os.path.realpath(music)

    with open(PLAYLIST_PATH, 'r') as f:
        musics = set([l.strip() for l in f.readlines()])

    musics.add(music_path)
    with open(PLAYLIST_PATH, 'w') as f:
        for path in musics:
            f.write(path.strip() + '\n')

    click.echo('"{}" added to playlist'.format(music))

if __name__ == '__main__':
    cli()
