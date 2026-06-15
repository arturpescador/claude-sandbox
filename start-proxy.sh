#!/usr/bin/env bash

set -euo pipefail

NETWORK_NAME="claude-net"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    docker network create "$NETWORK_NAME"
fi

docker rm -f claude-proxy >/dev/null 2>&1 || true

docker run -d \
    --name claude-proxy \
    --network "$NETWORK_NAME" \
    -p 3128:3128 \
    -v "$SCRIPT_DIR/squid.conf:/etc/squid/squid.conf:ro" \
    ubuntu/squid