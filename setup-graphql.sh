#!/bin/bash
# Create express app and configure apache httpd server
# creates sample-application in current directory (where the script is run from)
# To use run following commands from lightsail ssh session prompt:
# > git clone https://gist.github.com/strickc/9f59702d4fc47ef18ee45316448d73e2 quickstart
# > cd quickstart && ./lightsail-nodejs-quickstart.sh

# stop script on error
set -e

FOLDER=$1
if [ -z "$1" ]; then
  echo No folder path supplied.  Using \"../test\"
  FOLDER=../test
fi

# create the server
./create-graphql-server.sh $FOLDER

./configure-apache.sh $FOLDER

node $FOLDER/src/index.js
