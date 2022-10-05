#!/bin/bash

mysql << EOF
-- create user and grant all privileges
create user "$1"@'%' identified by "$2";
grant all privileges on *.* to "$1"@'%';
create user "$1"@'localhost' identified by "$2";
grant all privileges on *.* to "$1"@'localhost';

-- flush privileges so new users and privileges are active
FLUSH PRIVILEGES;
EOF