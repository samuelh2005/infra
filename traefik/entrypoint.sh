#!/bin/sh
exec traefik \
  --api.insecure=false \
  --api.dashboard=true \
  --providers.docker=true \
  --providers.docker.exposedbydefault=false \
  --providers.docker.network=proxy \
  --entryPoints.web.address=:80 \
  --entryPoints.websecure.address=:443 \
  --entryPoints.websecure.http.tls=true \
  --entryPoints.web.http.redirections.entryPoint.to=websecure \
  --entryPoints.web.http.redirections.entryPoint.scheme=https \
  --certificatesresolvers.cf.acme.email="$CF_API_EMAIL" \
  --certificatesresolvers.cf.acme.storage=/letsencrypt/acme.json \
  --certificatesresolvers.cf.acme.dnschallenge=true \
  --certificatesresolvers.cf.acme.dnschallenge.provider=cloudflare
