#!/bin/bash

# stop script on error
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# check if path is supplied
if [ -z $1 ]; then
  echo "Must supply folder to create app in as an argument"
  exit 1
else
  if [ -d $1 ] && [ ! -z "$( ls -A $1 )" ]; then
    echo "$1 is not empty.  Must supply empty directory as an arguement"
    exit 1
  fi
fi
APP_DIR=$1
echo creating graphql server app in directory $APP_DIR

# https://docs.bitnami.com/aws/infrastructure/nodejs/get-started/get-started/
echo Installing yarn
sudo npm -g install yarn

mkdir -p $APP_DIR/temp
# cd $APP_DIR
# yarn init -y

# yarn add graphql-yoga

# # copy templates into project
# cp -r $SCRIPT_DIR/templates/src .

git clone https://github.com/prisma/prisma-examples/ $APP_DIR/temp
cp -r $APP_DIR/temp/node/graphql/* $APP_DIR
rm -rf $APP_DIR/temp
cd $APP_DIR
yarn install
sudo npm -g install prisma
prisma deploy
