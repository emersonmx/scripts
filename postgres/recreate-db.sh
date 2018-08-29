#!/bin/bash

if [ -f .env ]; then
    source .env
else
    echo "Copie o .env.example para .env, edite as variáveis e execute o script novamente"
    exit
fi

kill_connections() {
    psql -h $LOCAL_HOST -U $LOCAL_USER -c "select pg_terminate_backend(pg_stat_activity.pid) from pg_stat_activity where pg_stat_activity.datname = '$1' and pid <> pg_backend_pid();"
}

kill_connections "$LOCAL_DB-new"
dropdb --if-exists -h $LOCAL_HOST -U $LOCAL_USER "$LOCAL_DB-new"
createdb -h $LOCAL_HOST -U $LOCAL_USER "$LOCAL_DB-new"

rm -f $SQL_FILE
pg_dump -v -h $ONLINE_HOST -U $ONLINE_USER $ONLINE_DB > $SQL_FILE
psql -h $LOCAL_HOST -U $LOCAL_USER "$LOCAL_DB-new" < $SQL_FILE

kill_connections "$LOCAL_DB"
kill_connections "$LOCAL_DB-new"
dropdb --if-exists -h $LOCAL_HOST -U $LOCAL_USER $LOCAL_DB
psql -h $LOCAL_HOST -U $LOCAL_USER -c "alter database \"$LOCAL_DB-new\" rename to \"$LOCAL_DB\";"
