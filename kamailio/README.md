# Kamailio IMS Docker Example

This directory builds a single reusable Kamailio image and runs it as `pcscf`, `icscf`, and `scscf` with Docker Compose.

The base image is `debian:trixie-slim`, and the Kamailio packages come from the official `kamailio61` APT repository. The configs are derived from the upstream `misc/examples/ims` samples and then adapted for Docker templating and a shared MariaDB schema.

## What this stack includes

- One Kamailio image for all three IMS roles
- Example MariaDB bootstrap for the standard, presence, IMS dialog, P-CSCF usrloc, S-CSCF usrloc, charging, and I-CSCF lookup tables
- Diameter peer templates for P-CSCF, I-CSCF, and S-CSCF
- Compose wiring for a lab deployment

## What this stack does not include

- A full HSS
- A PCRF/OCS
- RTP engine, SBC, or production TLS/IPsec wiring

Those integrations are left as external peers. The starter configs explicitly disable the features that require them so the containers can boot cleanly in a basic lab.

## Usage

1. Copy `.env.example` to `.env` and replace the example realms, FQDNs, DB passwords, and Diameter peers.
2. Start the stack with `docker compose up --build`.
3. Add DNS or `/etc/hosts` records so your UEs and peer IMS components can resolve the configured FQDNs.

## Notes

- `initdb` seeds the `s_cscf` and trusted-domain tables for the example realm.
- The `pcscf`, `icscf`, and `scscf` configs expect a standards-compliant HSS on the Cx interface once you move beyond boot validation.
- If you re-enable Rx, Ro, RTP relaying, IPsec, or XML-RPC, you must also wire the corresponding external services and kernel capabilities.
