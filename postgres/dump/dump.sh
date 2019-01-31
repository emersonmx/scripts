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

OUTPUT_SCHEMA_SQL="$SCRIPT_DIR/${OUTPUT_NAME_FILE}_schema_$(date +%Y%m%d).sql"
OUTPUT_DATA_SQL="$SCRIPT_DIR/${OUTPUT_NAME_FILE}_data_$(date +%Y%m%d).sql"

rm -f "$OUTPUT_SCHEMA_SQL"
rm -f "$OUTPUT_DATA_SQL"

echo 'Exportando schemas...'
pg_dump -v --schema-only > "$OUTPUT_SCHEMA_SQL"

echo '---'

echo 'Exportando dados...'
pg_dump -v \
    --data-only \
    --table=advertisements \
    --table=author_content \
    --table=authors \
    --table=banners \
    --table=book_boxes \
    --table=book_limitation_pages \
    --table=book_product \
    --table=books \
    --table=bump_offer_product_version \
    --table=bump_offers \
    --table=content_filter \
    --table=content_relations \
    --table=contents \
    --table=coupons \
    --table=cross_sell_offer \
    --table=cross_sell_statistics \
    --table=cross_sells \
    --table=exit_popups \
    --table=filters \
    --table=folder_product \
    --table=folders \
    --table=gift_pivot_renewal_offers \
    --table=gift_renewal_offers \
    --table=gifts \
    --table=linked_version_product_version \
    --table=linked_versions \
    --table=member_notifications \
    --table=messages \
    --table=migrations \
    --table=order_forms \
    --table=photo_albums \
    --table=product_version_renewal_offer \
    --table=product_versions \
    --table=products \
    --table=products_to_cancel \
    --table=quotes \
    --table=renewal_offers \
    --table=reports \
    --table=reviews \
    --table=settings \
    --table=social_posts \
    --table=tagging_tag_groups \
    --table=tagging_tagged \
    --table=tagging_tags \
    --table=users \
    > "$OUTPUT_DATA_SQL"

ln -sf "$OUTPUT_SCHEMA_SQL" "$SCHEMA_SQL_FILE"
ln -sf "$OUTPUT_DATA_SQL" "$DATA_SQL_FILE"
