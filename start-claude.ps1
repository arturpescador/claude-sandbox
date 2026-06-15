param()

$NETWORK_NAME  = "claude-net"
$IMAGE_NAME    = "claude-sandbox"
$CONTAINER_NAME = "claude-sandbox"
$PROXY_NAME    = "claude-proxy"

$PROJECT_DIR = "$env:USERPROFILE\claude-sandbox\src"
$OUTPUT_DIR  = "$env:USERPROFILE\claude-sandbox\output"
$CONFIG_DIR  = "$env:USERPROFILE\.config\claude"

New-Item -ItemType Directory -Force -Path $PROJECT_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $OUTPUT_DIR  | Out-Null
New-Item -ItemType Directory -Force -Path $CONFIG_DIR  | Out-Null

# Create network if it does not exist
$networks = docker network ls --format "{{.Name}}" 2>$null
if ($networks -notcontains $NETWORK_NAME) {
    Write-Host "Creating Docker network: $NETWORK_NAME"
    docker network create $NETWORK_NAME
}

# Build image
docker build -t $IMAGE_NAME -f docker/Dockerfile .

# Remove old container if present
docker rm -f $CONTAINER_NAME 2>$null | Out-Null

# Detect proxy
$running = docker ps --format "{{.Names}}" 2>$null
if ($running -contains $PROXY_NAME) {
    Write-Host "Restricted mode enabled (proxy detected)"
    docker run -it --rm `
        --name $CONTAINER_NAME `
        --network $NETWORK_NAME `
        -e HTTP_PROXY="http://${PROXY_NAME}:3128" `
        -e HTTPS_PROXY="http://${PROXY_NAME}:3128" `
        -e http_proxy="http://${PROXY_NAME}:3128" `
        -e https_proxy="http://${PROXY_NAME}:3128" `
        -v "${PROJECT_DIR}:/workspace" `
        -v "${OUTPUT_DIR}:/output" `
        -v "${CONFIG_DIR}:/home/claude/.config/claude" `
        -w /workspace `
        $IMAGE_NAME
} else {
    Write-Host "Normal mode enabled (no proxy detected)"
    docker run -it --rm `
        --name $CONTAINER_NAME `
        -v "${PROJECT_DIR}:/workspace" `
        -v "${OUTPUT_DIR}:/output" `
        -v "${CONFIG_DIR}:/home/claude/.config/claude" `
        -w /workspace `
        $IMAGE_NAME
}
