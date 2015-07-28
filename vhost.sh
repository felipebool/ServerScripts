#!/bin/bash
# script
#     vhost.sh
#
# what it does?
#     Configure an Apache virtual host
#
# usage
#     sudo ./vhost.sh [<server_name> <user-owner>] | -v
#  - <server_name>: domain name, without www, e.g. awesomeness.com
#  - <user-owner>: user will be used, e.g. www-data
#  - -v: show this message
#
# author: felipe lopes - bolzin [at] gmail [dot] com
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

SERVER_NAME=$1
SERVER_ALIAS="www."$1
SERVER_ADMIN="webmaster@$1"
DOCUMENT_ROOT="$1/public_html"

VHOST_FILE="/etc/apache2/sites-available/$SERVER_NAME.conf"

INDEX="<?php echo <h1>$1</h1> ?>"

VHOST_CONTENT=$(cat <<EOF 
<VirtualHost *:80>
   ServerAdmin $SERVER_ADMIN
   ServerName $SERVER_NAME
   ServerAlias $SERVER_ALIAS
   DocumentRoot $DOCUMENT_ROOT

   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined
</Virtualhost>
EOF)

# test if root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# test if apache2 exist
dpkg --get-selections | grep apache2 -q
if [[ $? != 0 ]]; then
   echo "Apache2 not installed"
   exit 1
fi

# test if vhost is being used
if [ ! -d $DOCUMENT_ROOT ]; then
   echo "$DOCUMENT_ROOT already being used"
   exit 1
fi

# change permission to /var/www to 755
chmod 755 /var/www

# create and set permission to document root
mkdir -p $DOCUMENT_ROOT
chown -R $2:$2 $DOCUMENT_ROOT

# create an index.php inside document root
echo $INDEX > $DOCUMENT_ROOT/index.php

# create vhost conf file
echo $VHOST_CONTENT >> $VHOST_FILE

# enable vhost
a2ensite $SERVER_NAME

service apache2 restart
