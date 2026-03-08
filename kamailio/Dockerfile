FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates wget gnupg gettext-base default-mysql-client tini \
    && wget -qO- https://deb.kamailio.org/kamailiodebkey.gpg | gpg --dearmor >/usr/share/keyrings/kamailio.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/kamailio.gpg] http://deb.kamailio.org/kamailio61 trixie main" >/etc/apt/sources.list.d/kamailio.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        kamailio \
        kamailio-extra-modules \
        kamailio-ims-modules \
        kamailio-json-modules \
        kamailio-mysql-modules \
        kamailio-outbound-modules \
        kamailio-presence-modules \
        kamailio-sctp-modules \
        kamailio-tls-modules \
        kamailio-utils-modules \
        kamailio-xml-modules \
    && rm -rf /var/lib/apt/lists/*

COPY config /etc/kamailio
COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY docker/init-db.sh /usr/local/bin/init-db.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/init-db.sh \
    && ln -s /etc/kamailio/pcscf /etc/kamailio_pcscf \
    && ln -s /etc/kamailio/icscf /etc/kamailio_icscf \
    && ln -s /etc/kamailio/scscf /etc/kamailio_scscf

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/docker-entrypoint.sh"]
CMD ["kamailio"]
