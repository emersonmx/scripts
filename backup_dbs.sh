#!/bin/sh

psql -qAt -U postgres -c 'select datname from pg_database where datallowconn' | xargs -I X pg_dump -U postgres -C -f X.sql X
