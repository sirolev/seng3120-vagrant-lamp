#!/bin/bash

mysql << EOF
-- delete the anonymous user
DELETE FROM mysql.user WHERE User='';

-- don't let root log in remotely (good idea)
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- drop the test db
DROP DATABASE IF EXISTS test;

-- remove test db privileges
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- flush privileges so new users and privileges are active
FLUSH PRIVILEGES;
EOF