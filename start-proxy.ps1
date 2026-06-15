param()

$NETWORK_NAME = "claude-net"
$SCRIPT_DIR   = $PSScriptRoot

$networks = docker network ls --format "{{.Name}}" 2>$null
if ($networks -notcontains $NETWORK_NAME) {
    docker network create $NETWORK_NAME
}

docker rm -f claude-proxy 2>$null | Out-Null

docker run -d `
    --name claude-proxy `
    --network $NETWORK_NAME `
    -p 3128:3128 `
    -v "${SCRIPT_DIR}\squid.conf:/etc/squid/squid.conf:ro" `
    ubuntu/squid
