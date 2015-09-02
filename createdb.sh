#!/bin/bash
# script
#  createdb.sh
#
# what it does?
#  Create a new user and database
#
# usage: ./createdb <db_user> <db_user_pass> <new_db_name>
#  <db_user>: new db user
#  <db_user_pass>: new db user pass
#  <new_db_name>: new db name
#
# author
#  felipe lopes - bolzin [at] gmail [dot] com
#
# Copyright (c) 2015 Felipe Lopes
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# TODO
# how can I run it safely without prompting root password...?

DB_USER=$1
DB_PASS=$2
DB_NAME=$3
MYSQL=$(which mysql)

CREATE_DB="CREATE DATABASE $DB_NAME;"
CREATE_USER="CREATE USER $DB_USER@localhost IDENTIFIED BY '$DB_PASS';"
PRIVILEGES="GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@localhost;"
FLUSH="FLUSH PRIVILEGES;"

# test usage
if [ $# -ne 3 ]; then
cat <<EOF
usage: ./createdb <db_user> <db_user_pass> <new_db_name>
   <db_user>: new db user
   <db_user_pass>: new db user pass
   <new_db_name>: new db name
EOF
   exit 1
fi

CREATION="${CREATE_DB} ${CREATE_USER} ${PRIVILEGES} ${FLUSH}"
$MYSQL -u root -p -e "$CREATION"

exit 0

