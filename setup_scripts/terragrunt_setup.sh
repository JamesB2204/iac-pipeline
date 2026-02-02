#!/usr/bin/env bash
set -xe

SUDO=''
if [ "$(id -u)" -ne 0 ]; then
  SUDO='sudo'
fi

if command -v terragrunt &> /dev/null; then
  echo "Terragrunt is already installed."
  terragrunt --version
  exit 0
fi

$SUDO apt-get update -y

$SUDO apt-get install -y curl unzip tar

ASSET_URL=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest \
  | grep "browser_download_url.*linux_amd64" \
  | cut -d '"' -f 4 \
  | head -n 1)

if [ -z "$ASSET_URL" ]; then
  echo "Error: Could not find Terragrunt Linux AMD64 release."
  exit 1
fi

curl -L -o terragrunt_asset "$ASSET_URL"

# Handle .tar.gz, .zip, or bare binary
if [[ "$ASSET_URL" == *.tar.gz ]]; then
  tar -xzf terragrunt_asset
elif [[ "$ASSET_URL" == *.zip ]]; then
  unzip terragrunt_asset
else
  mv terragrunt_asset terragrunt
fi

chmod +x terragrunt
$SUDO mv terragrunt /usr/local/bin/

echo "Terragrunt version:"
terragrunt --version
