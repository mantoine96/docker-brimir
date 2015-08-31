#!/bin/bash
# This script is used by the Dockerfile, when setting up a container. It can
# also be used to easily setup your PostgreSQL database.
#
# Call this script as root, with one argument: the path to your Brimir root.

# generate a secure password 
PW=`pwgen -s 32`

# add database, user and permissions
/etc/init.d/postgresql start
su - postgres -c "echo \"CREATE DATABASE brimir;\" | psql" postgres
su - postgres -c "echo \"CREATE USER brimir WITH ENCRYPTED PASSWORD '$PW';\" | psql" postgres
su - postgres -c "echo \"GRANT ALL PRIVILEGES ON DATABASE brimir TO brimir;\" | psql" postgres
/etc/init.d/postgresql restart
# create database config file
echo "
production:
  adapter: postgresql
  host: localhost
  database: brimir
  user: brimir
  password: $PW
" > $1/config/database.yml
