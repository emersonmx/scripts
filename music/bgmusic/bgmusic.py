#!/usr/bin/env python
# -*- coding: utf-8 -*-

import click

@click.group()
def cli():
    pass

@cli.command()
def play():
    click.echo('hello')
