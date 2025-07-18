#!/bin/bash

set -euo pipefail

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No color

usage() {
    printf "${YELLOW}Usage:${NC} %s <source-registry> <source-image[:tag]> <target-registry> <target-image[:tag]>\n" "$0"
    printf "Example: %s https://hub.docker.com/library python:3.9-alpine MyTargetRegistry.com python:3.9-alpine\n" "$0"
    exit 1
}

strip_protocol() {
    echo "${1#http://}" | sed 's/^https:\/\///'
}

parse_image_tag() {
    local image="$1"
    local default_tag="latest"
    if [[ "$image" == *:* ]]; then
        echo "${image%%:*} ${image##*:}"
    else
        echo "$image $default_tag"
    fi
}

log() {
    printf "${GREEN}[INFO]${NC} %s\n" "$1"
}

error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1" >&2
    exit 1
}

# ---- Main script ----

if [[ $# -ne 4 ]]; then
    usage
fi

SRC_REGISTRY=$(strip_protocol "$1")
SRC_IMAGE_TAG="$2"
TGT_REGISTRY=$(strip_protocol "$3")
TGT_IMAGE_TAG="$4"

read SRC_IMAGE SRC_TAG <<< "$(parse_image_tag "$SRC_IMAGE_TAG")"
read TGT_IMAGE TGT_TAG <<< "$(parse_image_tag "$TGT_IMAGE_TAG")"

FULL_SRC_IMAGE="${SRC_REGISTRY}/${SRC_IMAGE}:${SRC_TAG}"
FULL_TGT_IMAGE="${TGT_REGISTRY}/${TGT_IMAGE}:${TGT_TAG}"

log "Pulling source image: $FULL_SRC_IMAGE"
docker pull "$FULL_SRC_IMAGE" || error "Failed to pull image: $FULL_SRC_IMAGE"

log "Tagging image as: $FULL_TGT_IMAGE"
docker tag "$FULL_SRC_IMAGE" "$FULL_TGT_IMAGE" || error "Failed to tag image"

log "Pushing to target registry: $FULL_TGT_IMAGE"
docker push "$FULL_TGT_IMAGE" || error "Failed to push image"

log "Image transfer complete!"
