#!/bin/bash

set -e

# Function to display messages with color.
log() {
    local color=$1
    local message=$2
    local reset='\033[0m'
    echo -e "${color}${message}${reset}"
}

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLSTMO_COLOR='\033[38;5;47m'  # Custom color #22c55e

# ASCII Art Header
display_header() {
    echo -e "${BLSTMO_COLOR}"
    echo "██████╗ ██╗     ███████╗████████╗███╗   ███╗ ██████╗     ██████╗ ██████╗ ███╗   ███╗"
    echo "██╔══██╗██║     ██╔════╝╚══██╔══╝████╗ ████║██╔═══██╗   ██╔════╝██╔═══██╗████╗ ████║"
    echo "██████╔╝██║     ███████╗   ██║   ██╔████╔██║██║   ██║   ██║     ██║   ██║██╔████╔██║"
    echo "██╔══██╗██║     ╚════██║   ██║   ██║╚██╔╝██║██║   ██║   ██║     ██║   ██║██║╚██╔╝██║"
    echo "██████╔╝███████╗███████║   ██║   ██║ ╚═╝ ██║╚██████╔╝██╗╚██████╗╚██████╔╝██║ ╚═╝ ██║"
    echo "╚═════╝ ╚══════╝╚══════╝   ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝"
    echo -e "${CYAN}https://github.com/blstmo/blstmo-templates${reset}"
    echo -e "${CYAN}https://blstmo.com${reset}"
    echo -e "${reset}"
}

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    log "${RED}" "Please run as root or use sudo."
    exit 1
fi

display_header

# Update the package index based on the detected package manager.
log "${YELLOW}" "Updating package index..."
if command -v apt-get &> /dev/null; then
    apt-get update -y
elif command -v dnf &> /dev/null; then
    dnf update -y
elif command -v yum &> /dev/null; then
    yum update -y
elif command -v pacman &> /dev/null; then
    pacman -Syu --noconfirm
elif command -v apk &> /dev/null; then
    apk update
elif command -v zypper &> /dev/null; then
    zypper refresh -y
else
    log "${RED}" "Unsupported package manager. Please update your system manually."
    exit 1
fi

# Install prerequisites (curl and jq)
log "${YELLOW}" "Installing prerequisites..."
install_package() {
    package_name=$1
    if command -v apt-get &> /dev/null; then
        apt-get install -y "$package_name"
    elif command -v dnf &> /dev/null; then
        dnf install -y "$package_name"
    elif command -v yum &> /dev/null; then
        yum install -y "$package_name"
    elif command -v pacman &> /dev/null; then
        pacman -S --noconfirm "$package_name"
    elif command -v apk &> /dev/null; then
        apk add --no-cache "$package_name"
    elif command -v zypper &> /dev/null; then
        zypper install -y "$package_name"
    else
        log "${RED}" "Package manager not supported for installing ${package_name}."
        exit 1
    fi
}

# Install curl
if ! command -v curl &> /dev/null; then
    log "${YELLOW}" "Installing curl..."
    install_package curl
fi

# Check if jq is installed, if not, install it.
if ! command -v jq &> /dev/null; then
    log "${YELLOW}" "'jq' not found. Installing jq..."
    install_package jq
fi

# Install Docker
log "${YELLOW}" "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# Start and enable Docker service
log "${YELLOW}" "Starting and enabling Docker service..."
systemctl start docker
systemctl enable docker

# Install Docker Compose plugin
log "${YELLOW}" "Installing Docker Compose plugin..."
DOCKER_CONFIG=${DOCKER_CONFIG:-/usr/local/lib/docker}
mkdir -p "$DOCKER_CONFIG/cli-plugins"
ARCH=$(uname -m)
case $ARCH in
    x86_64) ARCH="x86_64" ;;
    aarch64) ARCH="aarch64" ;;
    *) log "${RED}" "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Fetch the latest release version of Docker Compose
LATEST_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)
if [ -z "$LATEST_VERSION" ]; then
    log "${RED}" "Failed to fetch the latest Docker Compose version."
    exit 1
fi

# Download the latest Docker Compose binary
curl -SL "https://github.com/docker/compose/releases/download/$LATEST_VERSION/docker-compose-linux-$ARCH" -o "$DOCKER_CONFIG/cli-plugins/docker-compose"
chmod +x "$DOCKER_CONFIG/cli-plugins/docker-compose"

# Verification of installations
log "${YELLOW}" "Verifying Docker installation..."
docker --version
docker compose version

log "${GREEN}" "Docker and Docker Compose have been installed successfully."
