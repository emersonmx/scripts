#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -f .env ]; then
    source "$SCRIPT_DIR/.env"
else
    echo "Copy .env.example to .env, edit and run script again"
    exit
fi

export PGHOST=$DB_HOST
export PGUSER=$DB_NAME
export PGDATABASE=$DB_USER

rm -f "$SCHEMA_SQL_FILE"
rm -f "$DATA_SQL_FILE"

echo 'Exportando schemas...'
pg_dump -v --schema-only > "$SCHEMA_SQL_FILE"

echo '---'

echo 'Exportando dados...'
pg_dump -v \
    --data-only \
    --table=migrations \
    > "$DATA_SQL_FILE"
