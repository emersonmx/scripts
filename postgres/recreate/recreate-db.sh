#!/bin/bash

if [ -f .env ]; then
    source .env
else
    echo "Copy .env.example to .env, edit and run script again"
    exit
fi

echo "THIS OPERATION CAN BE DANGEROUS AND MAKE A LOT OF DAMAGE!!!"
echo "Verify the connection to the source and destination database are correct"
echo "before continuing."
echo ""
echo "OPERATIONS"
echo " - Connections to \"$DEST_USER@$DEST_HOST/$DEST_DB-new\" will be killed;"
echo " - The \"$DEST_USER@$DEST_HOST/$DEST_DB-new\" will be recreated (drop/create);"
echo " - The old dump \"$SQL_FILE\" will be deleted;"
echo " - A new dump from \"$SRC_USER@$SRC_HOST/$SRC_DB\" named \"$SQL_FILE\" will be created;"
echo " - The dump from \"$SRC_USER@$SRC_HOST/$SRC_DB\" will be imported in \"$DEST_USER@$DEST_HOST/$DEST_DB-new\";"
echo " - Connections to \"$DEST_USER@$DEST_HOST/$DEST_DB\" and \"$DEST_USER@$DEST_HOST/$DEST_DB-new\" will be killed;"
echo " - The \"$DEST_USER@$DEST_HOST/$DEST_DB\" will be deleted;"
echo " - The \"$DEST_USER@$DEST_HOST/$DEST_DB-new\" will be renamed to \"$DEST_USER@$DEST_HOST/$DEST_DB\"."
echo ""

while true; do
    read -p "Continue (yes/no)? " yesno
    case $yesno in
        no) exit;;
        *) echo "Please answer yes or no."
    esac
done

kill_connections() {
    psql -h $DEST_HOST -U $DEST_USER -c "select pg_terminate_backend(pg_stat_activity.pid) from pg_stat_activity where pg_stat_activity.datname = '$1' and pid <> pg_backend_pid();"
}

kill_connections "$DEST_DB-new"
dropdb --if-exists -h $DEST_HOST -U $DEST_USER "$DEST_DB-new"
createdb -h $DEST_HOST -U $DEST_USER "$DEST_DB-new"

rm -f $SQL_FILE
pg_dump -v -h $SRC_HOST -U $SRC_USER $SRC_DB > $SQL_FILE
psql -h $DEST_HOST -U $DEST_USER "$DEST_DB-new" < $SQL_FILE

kill_connections "$DEST_DB"
kill_connections "$DEST_DB-new"
dropdb --if-exists -h $DEST_HOST -U $DEST_USER $DEST_DB
psql -h $DEST_HOST -U $DEST_USER -c "alter database \"$DEST_DB-new\" rename to \"$DEST_DB\";"
