#!/bin/bash
/usr/bin/mysqld_safe &
sleep 5
mysql -u root -p 123456 -e "CREATE DATABASE mydb"
mysql -u root mydb < /tmp/filler.sql
