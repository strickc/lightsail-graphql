#!/bin/bash

# stop script on error
set -e

if [ ! -d /opt/bitnami/apache2 ]; then
  echo Not configuring apache - Bitnami nodejs environment not detected
  exit 0
fi

# check if path is supplied
if [ -z $1 ]; then
  echo "Must supply folder to create app in as an argument"
  exit 1
else
  if [ -d $1 ] && [ ! -f $1/package.json ]; then
    echo "$1/package.json does not exist.  Must have a package initialized at $1"
    exit 1
  fi
fi
APP_FOLDER=$( cd $1 && pwd )

# Configure apache to forward to the express app port
# https://docs.bitnami.com/aws/infrastructure/nodejs/administration/create-custom-application-nodejs/
cd $APP_FOLDER
sudo mkdir -p conf
sudo mkdir -p public
# make htdocs symlink to public folder
ln -s public htdocs
echo "Include \"$APP_FOLDER/conf/httpd-app.conf\"" > conf/httpd-prefix.conf 
echo 'ProxyPass / http://127.0.0.1:4000/
ProxyPassReverse / http://127.0.0.1:4000/' > conf/httpd-app.conf
# edit apache configuration to include the app
echo "Include \"$APP_FOLDER/conf/httpd-prefix.conf\"" > /opt/bitnami/apache2/conf/bitnami/bitnami-apps-prefix.conf
# restart apache
echo "Restarting apache httpd: sudo /opt/bitnami/ctlscript.sh restart apache"
sudo /opt/bitnami/ctlscript.sh restart apache
