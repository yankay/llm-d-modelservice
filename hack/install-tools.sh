#!/bin/bash

set -euo pipefail

# Tool versions

# https://github.com/helm/chart-testing
CT_VERSION="v3.13.0"
# https://github.com/helm/helm
HELM_VERSION="v3.18.5"
# https://pypi.org/project/yamale/
YAMALE_VERSION="6.0.0"
# https://pypi.org/project/yamllint/
YAMLLINT_VERSION="1.37.1"

# Detect OS and Architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case $ARCH in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac


install_tar_binary() {
  local install_path="$1"
  local download_url="$2"
  local binary_path="$3"
  local binary_name="${4:-$(basename "$binary_path")}"

  mkdir -p "$install_path"

  # Determine tar flags based on file extension
  local tar_flags="-z --extract --touch --transform s/.*/$binary_name/"

  echo "Installing $binary_name..."
  curl -fsSL "$download_url" | tar $tar_flags -C "$install_path" "$binary_path"
  chmod +x "$install_path/$binary_name"
}

install_ct() {
  local install_path="$1"
  
  install_tar_binary "$install_path" \
    "https://github.com/helm/chart-testing/releases/download/$CT_VERSION/chart-testing_${CT_VERSION:1}_${OS}_${ARCH}.tar.gz" \
    "ct"

  echo "Installing Python dependencies..."
  pip install "yamale==$YAMALE_VERSION" "yamllint==$YAMLLINT_VERSION"
}

install_helm() {
  local install_path="$1"
  
  install_tar_binary "$install_path" \
    "https://get.helm.sh/helm-$HELM_VERSION-$OS-$ARCH.tar.gz" \
    "$OS-$ARCH/helm" \
    "helm"
}


# Main execution
install_tool() {
  local install_path="$1"
  local tool="$2"
  "install_$tool" "$install_path"
}

# Set default TOOLS_PATH if not provided
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_PATH="${TOOLS_PATH:-$PROJECT_DIR/bin}"

install_tool "$TOOLS_PATH" "${1}"