#!/usr/bin/env bash
sudo apt update
sudo apt install npm -y
curl https://buildittest.s3-eu-west-1.amazonaws.com/test-app.tar.gz -o test-app.tar.gz
tar -xvf test-app.tar.gz
cd test-app
npm start
