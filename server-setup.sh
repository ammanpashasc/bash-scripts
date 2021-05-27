#!/bin/bash


# This file will install:
# NodeJS v12 + npm
# PM2
# Nginx server
# Yarn

# TODO: Add options MongoDB, MYSQL, Postgres & Certbot 


#  Initial setup
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev

echo
echo
echo 'Install:'
read -p '     nodeJS? (y/N)' njs
read -p '     pm2 (y/N)' pmt
read -p '     nginx (y/N)' ngx
read -p '     yarn (y/N)' yrn


if [ $njs == 'y' ]
then
  echo installing nodeJS...
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt-get install -y nodejs && node -v && npm -v
fi


if [ $pmt == 'y' ]
then
  echo installing pm2...
  sudo npm install -g pm2
  sudo pm2 startup systemd
fi


if [ $ngx == 'y' ]
then
  echo installing nginx...
  sudo apt-get install -y nginx
  sudo systemctl status nginx
  cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bkp
fi


if [ $yrn == 'y' ]
then
  echo installing yarn...
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update && sudo apt install yarn
fi


echo
echo
echo Finished!
