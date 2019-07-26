#!/usr/bin/env bash

set -e

# Functions
wait_yum() {
    if [[ -e /var/run/yum.pid ]]; then
        tail --pid=$(cat /var/run/yum.pid) -f /dev/null
    fi
}

# Build Erlang
wait_yum
yum install -y gcc perl m4 openssl-devel ncurses-devel unixODBC unixODBC-devel libxslt
curl -Lo /tmp/otp_src_${ERLANG_VERSION}.tar.gz http://www.erlang.org/download/otp_src_${ERLANG_VERSION}.tar.gz
tar -C /tmp -zxf /tmp/otp_src_${ERLANG_VERSION}.tar.gz
cd $ERL_TOP
./configure  --prefix=/opt/erlang/${ERLANG_VERSION} --without-wx --without-javac
make -j$(nproc) && make -j$(nproc) install

# Configure Shell
cat >> /etc/profile.d/erl.sh <<EOL
export PATH="/opt/erlang/${ERLANG_VERSION}/bin:\$PATH"
EOL

# Clean all
wait_yum
yum autoremove -y gcc perl m4 openssl-devel ncurses-devel unixODBC-devel
cd && rm -rf /tmp/otp_src_${ERLANG_VERSION} /tmp/otp_src_${ERLANG_VERSION}.tar.gz
