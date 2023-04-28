#!/bin/bash

arch=$(uname -m)

if [ -z "$(ls -A "/opt/PhpStorm")" ]; then
    echo "/opt/PhpStorm is not installed -> donwloading"
    wget https://download.jetbrains.com/webide/PhpStorm-2023.1-$arch.tar.gz -O PhpStorm.tar.gz
    tar -xzf PhpStorm.tar.gz -C /opt/PhpStorm
    mv /opt/PhpStorm/PhpStorm-* /opt/PhpStorm/PhpStorm
    rm PhpStorm.tar.gz
fi

echo $SSH_PASSWORD | sudo -S service ssh start

if [ -z "$(ls -A "/opt/project")" ]; then
    git clone ${GIT_REPO} /opt/project
fi

REMOTE_DEV_TRUST_PROJECTS=true /opt/PhpStorm/PhpStorm/bin/remote-dev-server.sh warmup /opt/project

tail -f /dev/null
