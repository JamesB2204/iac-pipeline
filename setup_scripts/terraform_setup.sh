#!/bin/bash

set -xe

TERRAFORM_VERSION="latest"
INSTALL_DIR="$HOME/bin"  
OS="linux"
ARCH="amd64"

apt-get update && sudo apt-get install -y unzip jq curl

mkdir -p "$INSTALL_DIR"

get_latest_version() {
    curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version
}

if [ "$TERRAFORM_VERSION" == "latest" ]; then
    TERRAFORM_VERSION=$(get_latest_version)
fi

TERRAFORM_ZIP="terraform_${TERRAFORM_VERSION}_${OS}_${ARCH}.zip"
DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ZIP}"

curl -o "/tmp/${TERRAFORM_ZIP}" "$DOWNLOAD_URL"

unzip -o "/tmp/${TERRAFORM_ZIP}" -d "$INSTALL_DIR"

rm "/tmp/${TERRAFORM_ZIP}"

if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
fi


source ~/.bashrc

# Verify installation
echo "Terraform version installed:"
"$INSTALL_DIR/terraform" version


