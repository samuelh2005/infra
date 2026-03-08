#!/bin/sh
set -eu

render_templates() {
    role_dir="/etc/kamailio/${IMS_ROLE}"
    if [ ! -d "${role_dir}" ]; then
        echo "Unknown IMS_ROLE: ${IMS_ROLE}" >&2
        exit 1
    fi

    find "${role_dir}" -type f -name '*.tmpl' | while read -r template; do
        envsubst < "${template}" > "${template%.tmpl}"
    done
}

run_kamailio() {
    : "${IMS_ROLE:?IMS_ROLE is required}"
    : "${ROLE_FQDN:?ROLE_FQDN is required}"
    : "${IMS_REALM:?IMS_REALM is required}"

    render_templates

    exec /usr/sbin/kamailio -DD -E -f "/etc/kamailio/${IMS_ROLE}/kamailio.cfg"
}

case "${1:-kamailio}" in
    init-db)
        exec /usr/local/bin/init-db.sh
        ;;
    kamailio|"")
        run_kamailio
        ;;
    *)
        exec "$@"
        ;;
esac
