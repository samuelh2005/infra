#!/bin/sh
set -eu

: "${DB_HOST:?DB_HOST is required}"
: "${DB_NAME:?DB_NAME is required}"
: "${DB_USER:?DB_USER is required}"
: "${DB_PASSWORD:?DB_PASSWORD is required}"
: "${DB_ROOT_PASSWORD:?DB_ROOT_PASSWORD is required}"
: "${IMS_REALM:?IMS_REALM is required}"
: "${SCSCF_FQDN:?SCSCF_FQDN is required}"
: "${SCSCF_SIP_PORT:?SCSCF_SIP_PORT is required}"

export MYSQL_PWD="${DB_ROOT_PASSWORD}"

until mysqladmin ping -h "${DB_HOST}" -u root --silent >/dev/null 2>&1; do
    sleep 2
done

if mysql -h "${DB_HOST}" -u root -Nse "SELECT 1 FROM information_schema.tables WHERE table_schema='${DB_NAME}' AND table_name='version'" | grep -q 1; then
    echo "Kamailio schema already present in ${DB_NAME}, skipping init"
    exit 0
fi

mysql -h "${DB_HOST}" -u root -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
mysql -h "${DB_HOST}" -u root -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%'; FLUSH PRIVILEGES;"

for sql in \
    /etc/kamailio/sql/standard-create.sql \
    /etc/kamailio/sql/presence-create.sql \
    /etc/kamailio/sql/ims_dialog-create.sql \
    /etc/kamailio/sql/ims_usrloc_pcscf-create.sql \
    /etc/kamailio/sql/ims_usrloc_scscf-create.sql \
    /etc/kamailio/sql/ims_charging-create.sql \
    /etc/kamailio/sql/icscf-schema.sql
do
    mysql -h "${DB_HOST}" -u root "${DB_NAME}" < "${sql}"
done

envsubst < /etc/kamailio/sql/ims-seed.sql.tmpl | mysql -h "${DB_HOST}" -u root "${DB_NAME}"

echo "Kamailio IMS schema initialized in ${DB_NAME}"
