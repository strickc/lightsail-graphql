#!/bin/bash

# stop script on error
set -e

# install prisma
npm install -g prisma

mkdir -p prisma-server
cd prisma-server
echo 'version: "3"
services:
  prisma:
    image: prismagraphql/prisma:1.22
    restart: always
    ports:
    - "4466:4466"
    environment:
      PRISMA_CONFIG: |
        port: 4466
        databases:
          default:
            connector: mysql
            host: mysql
            port: 3306
            user: root
            password: prisma
            migrations: true
  mysql:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: prisma
    volumes:
      - mysql:/var/lib/mysql
volumes:
  mysql:
' > docker-compose.yml

docker-compose up -d

