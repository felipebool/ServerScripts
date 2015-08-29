#!/bin/bash
# script
#  wordpress.sh
#
# what it does?
#  Download
#
# usage: sudo ./wordpress.sh
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

# settings
WPDIR=$1
WPURL="https://br.wordpress.org/latest-pt_BR.zip"
WPTEMPDIR=$WPDIR/wordpress
WPZIPPATH="$WPDIR/$(basename $WPURL)"
WPCONFIG=$WPDIR/wp-config.php

# download wordpress to WPDIR 
wget $WPURL -P $WPDIR

# extract zip content to WPDIR
unzip $WPZIPPATH -d $WPDIR

# moving files to WPDIR and removing wordpress dir
mv $WPTEMPDIR/* $WPDIR
rmdir $WPTEMPDIR

# creating wp-config.php -------------------------------------------------------
cat <<EOF > "$WPCONFIG"
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
# ------------------------------------------------------------------------------
