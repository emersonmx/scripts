#!/bin/sh

git remote | xargs -L1 git push --all
