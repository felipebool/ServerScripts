#!/bin/bash

not_running_as_root() {
   if [[ $EUID -ne 0 ]]; then return 0; fi
   return 1
}

if not_running_as_root; then
   echo "You must run this script as root!"
   echo "Exiting..."
   exit 23
fi

echo "Updating system before start installing..."
apt-get install update

echo "Installing Apache..."
apt-get install apache2

echo "Installing Mysql..."
apt-get install mysql-server

echo "Cleaning up Mysql installation [say yes to every question]..."
mysql_secure_installation

echo "Installing PHP..."
apt-get install php5 php-pear php5-mysql

echo "Reiniciando Apache"
service apache2 restart

# TODO
# --default-applications, -d:
# - htop
# - git
# - vim
# - ntp

exit 0

