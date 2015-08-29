#!/bin/bash
# script
#  addgit.sh
#
# what it does?
#  Create a new user called git and put it into a www-data group
#
# usage: sudo ./vhost.sh <server_name> <user-owner>
#  <server_name>: domain name, without www, e.g. awesomeness.com
#  <user-owner>: user will be used, e.g. www-data
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

# git user info
GITUSER="git"
GITHOME="/home/git"
GITCOMMENT="git user"
GITWEBGROUP="www-data"

GITSSHDIR="$HOME/.ssh"
GITAUTHORIZEDKEYS="$GITSSHDIR/authorized_keys"

# test if root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# create user git
useradd $GITUSER

# modify git user
usermod -c $GITCOMMENT -d $GITHOME -a -G $GITWEBGROUP

mkdir -m 700 $GITSSHDIR

touch $GITAUTHORIZEDKEYS
chmod 600 $GITAUTHORIZEDKEYS

chown -R $GITUSER:$GITUSER $GITHOME

