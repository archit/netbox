#!/usr/bin/env bash
set -euo pipefail
# NetBox token auth via the provision endpoint (v1 token: Authorization: Token <plaintext>)
# POST /api/users/tokens/provision/ {username, password, version: 1} -> {token: "..."}
# Used as testbot authTokenCommand; token sent as: Authorization: Token <token>
U="${NETBOX_ADMIN:-admin}"
P="${NETBOX_PASS:-Password123!}"
curl -sf -X POST "http://localhost:8092/api/users/tokens/provision/" \
  -H 'Content-Type: application/json' \
  -d "{\"username\":\"$U\",\"password\":\"$P\",\"version\":1}" \
  | python3 -c "import json,sys;print(json.load(sys.stdin)['token'])"
