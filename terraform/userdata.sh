#!/bin/bash -xe

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install nodejs npm git netcat -y

node -v

git clone https://github.com/viktorradnai/devops-test
cd devops-test
npm start & while ! nc -z localhost 3000; do
    sleep 1
done
curl -sf http://localhost:3000
echo
