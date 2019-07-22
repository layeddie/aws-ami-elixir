#!/usr/bin/env bash

set -e

# Install Elixir
yum install -y unzip
mkdir -p /opt/elixir/${ELIXIR_VERSION}/
curl -Lo /tmp/elixir.zip https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip
unzip /tmp/elixir.zip -d /opt/elixir/${ELIXIR_VERSION}/

# Configure Shell
cat >> /etc/profile.d/iex.sh <<EOL
export PATH="/opt/elixir/${ELIXIR_VERSION}/bin:$PATH"
EOL

# Clean all
yum autoremove -y unzip
cd && rm -rf /tmp/elixir.zip
