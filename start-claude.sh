#!/usr/bin/env bash

set -euo pipefail

NETWORK_NAME="claude-net"
IMAGE_NAME="claude-sandbox"
CONTAINER_NAME="claude-sandbox"
PROXY_NAME="claude-proxy"

PROJECT_DIR="$HOME/claude-sandbox/src"
OUTPUT_DIR="$HOME/claude-sandbox/output"
CONFIG_DIR="$HOME/.config/claude"

mkdir -p "$PROJECT_DIR"
mkdir -p "$OUTPUT_DIR"
mkdir -p "$CONFIG_DIR"

# Create network if it does not exist
if ! docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "Creating Docker network: $NETWORK_NAME"
    docker network create "$NETWORK_NAME"
fi

# Build image
docker build -t "$IMAGE_NAME" -f docker/Dockerfile .

# Remove old container if present
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

# Detect proxy
DOCKER_ARGS=""

if docker ps --format '{{.Names}}' | grep -qx "$PROXY_NAME"; then
    echo "Restricted mode enabled (proxy detected)"

    DOCKER_ARGS="
        --network $NETWORK_NAME
        -e HTTP_PROXY=http://$PROXY_NAME:3128
        -e HTTPS_PROXY=http://$PROXY_NAME:3128
        -e http_proxy=http://$PROXY_NAME:3128
        -e https_proxy=http://$PROXY_NAME:3128
    "
else
    echo "Normal mode enabled (no proxy detected)"
fi

eval docker run -it --rm \
    --name "$CONTAINER_NAME" \
    $DOCKER_ARGS \
    -v "$PROJECT_DIR:/workspace" \
    -v "$OUTPUT_DIR:/output" \
    -v "$CONFIG_DIR:/home/claude/.config/claude" \
    -w /workspace \
    "$IMAGE_NAME"