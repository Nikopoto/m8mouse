#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Installing m8mouse...${NC}"

if [ "$EUID" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    else
        echo -e "${RED}Not running as root and sudo is missing.${NC}"
        exit 1
    fi
else
    SUDO=""
fi

install_dependencies() {
    if command -v apt >/dev/null 2>&1; then
        echo -e "${GREEN}Using apt to install dependencies...${NC}"
        $SUDO apt update
        $SUDO apt install -y libhidapi-dev cmake build-essential pkg-config
    elif command -v dnf >/dev/null 2>&1; then
        echo -e "${GREEN}Using dnf to install dependencies...${NC}"
        $SUDO dnf makecache
        $SUDO dnf install -y hidapi-devel cmake gcc-c++ make pkgconf-pkg-config
    elif command -v pacman >/dev/null 2>&1; then
        echo -e "${GREEN}Using pacman to install dependencies...${NC}"
        $SUDO pacman -Syu --noconfirm --needed hidapi cmake base-devel pkgconf
    else
        echo -e "${RED}Unsupported package manager. Please install hidapi development files, cmake, build tools, and pkg-config manually.${NC}"
        exit 1
    fi
}

if ! install_dependencies; then
    echo -e "${RED}Failed to install dependencies, check your network or/and network manager.${NC}"
    exit 1
fi

mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local
cmake --build . -- -j"$(nproc)"
cmake --install .
cd ..

if command -v udevadm >/dev/null 2>&1; then
    $SUDO udevadm control --reload-rules
    $SUDO udevadm trigger
else
    echo -e "${RED}Warning: 'udevadm' command not found. Skipping udev rules reload.${NC}"
fi

echo -e "${GREEN}Installation done!${NC}"
echo "Make sure ${HOME}/.local/bin is in your PATH to run m8mouse."
