#!/bin/bash
# script
#  wordpress.sh
#
# what it does?
#  Download
#
# usage: sudo ./wordpress.sh location project_prefix
#  location: the path to where wordpress will be installed
#  project_prefix: little token used to ease projects organization
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

strong_pass() {
   SIZE=$1
   SPECIAL=(\! \@ \# \$ \% \& \* \_ \- \+ \= \{ \[ \} \] \^ \~ \> \< \. \,) 
   LOWER=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
   UPPER=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
   NUM=(0 1 2 3 4 5 6 7 8 9)
   PASS=""

   for i in $(seq 1 $SIZE); do
      WAY=$(((RANDOM % 4) + 1))
      case $WAY in
         1)PASS=$PASS${SPECIAL[$(((RANDOM % ${#SPECIAL[@]}) + 1))]};;
         2)PASS=$PASS${LOWER[$(((RANDOM % ${#LOWER[@]}) + 1))]};;
         3)PASS=$PASS${UPPER[$(((RANDOM % ${#UPPER[@]}) + 1))]};;
         4)PASS=$PASS${NUM[$(((RANDOM % ${#NUM[@]}) + 1))]};;
      esac
   done

   echo "$PASS"
}

output_wpconfig() {
#cat <<EOF > "$WPCONFIG"
cat <<EOF
<?php
define('DB_NAME', '$WPDBNAME');
define('DB_USER', '$WPDBUSER');
define('DB_PASSWORD', '$WPDBPASS');
define('DB_HOST', 'localhost');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

`curl -sS https://api.wordpress.org/secret-key/1.1/salt/`

\$table_prefix  = 'wp_';
define('WP_DEBUG', false);

/** Absolute path to the WordPress directory. */
if (!defined('ABSPATH'))
   define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
EOF
}

# test usage
if [ $# -ne 2 ]; then
cat <<EOF
usage: ./wordpress <wp_installation_path> <wp_project_name>
   <wp_installation_path>: absolute path where wordpress will be installed
   <wp_project_name>: wordpress project name, without spaces
EOF
   exit 1
fi

# settings
WPDIR=$1
WPURL="https://br.wordpress.org/latest-pt_BR.zip"
WPZIPPATH="$WPDIR/$(basename $WPURL)"
WPCONFIG=$WPDIR/wp-config.php

WPDBNAME=$2"_dbwp"
WPDBUSER=$2"_dbuser"
WPDBPASS=$(strong_pass 15)

WPADMINPANELUSER=$2"_admin"
WPADMINPANELPASS=$(strong_pass 15)

# download wordpress to WPDIR 
wget $WPURL -P $WPDIR

# extract zip content to WPDIR
unzip $WPZIPPATH -d $WPDIR

# moving files to WPDIR and removing wordpress dir
mv $WPDIR/wordpress/* $WPDIR
rmdir $WPDIR/wordpress

output_wpconfig

createdb $WPDBUSER $WPDBPASS $WPDBNAME

echo "wordpress installation info"
echo "- database"
echo -e "\twp db user: "$WPDBUSER
echo -e "\twp db name: "$WPDBNAME
echo -e "\twp db pass: "$WPDBPASS
echo "- wordpress"
echo -e "\twp admin panel user: "$WPADMINPANELUSER
echo -e "\twp admin panel pass: "$WPADMINPANELPASS

