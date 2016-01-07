#!/bin/bash

#        DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
#                    Version 2, December 2004 
#
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net> 
#
# Everyone is permitted to copy and distribute verbatim or modified 
# copies of this license document, and changing it is allowed as long 
# as the name is changed. 
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.


# TODO
# use mysql configuration file to store dbuser and dbpass
# put start and end time to log execution time
# logging backup file size
# create backup user
# backup is storing full path to files
# servername must come from command line

# Configuration ----------------------------------------------------------------
TIMESTAMP=$(date "+%a_%d_%m_%y")

# mysql stuff (change this)
DBUSER=""
DBPASS=""
SERVERNAME="DEV"

# directories to backup
WWW="/var/www"
GIT="/var/git"
# ------------------------------------------------------------------------------

# temporary directory structure
TMPROOTBACKUP=$(mktemp -d)

# backup file names
LOGICALSQLFILE=$TMPROOTBACKUP/$TIMESTAMP"_logical.sql"
LOGICALCOMPRESSED=$TMPROOTBACKUP/$TIMESTAMP"_logical.bkp.tar.gz"

WWWCOMPRESSED=$TMPROOTBACKUP/$TIMESTAMP"_varwww.bkp.tar.gz"
GITCOMPRESSED=$TMPROOTBACKUP/$TIMESTAMP"_vargit.bkp.tar.gz"

BACKUPSOURCE=$TMPROOTBACKUP/$TIMESTAMP"_backup_"$SERVERNAME".bkp.tar.gz"
BACKUPDESTINATION="/var/backup/"

not_running_as_root() {
   if [[ $EUID -ne 0 ]]; then return 0; fi
   return 1
}

logical_backup() {
   PARAMETERS="-u"$DBUSER" -p"$DBPASS" --all-databases --events"

   mysqldump $PARAMETERS > $LOGICALSQLFILE 2> /dev/null
   tar czf $LOGICALCOMPRESSED $LOGICALSQLFILE 2> /dev/null

   rm $LOGICALSQLFILE
}

phisical_backup() {
   tar czf $WWWCOMPRESSED $WWW 2> /dev/null
   tar czf $GITCOMPRESSED $GIT 2> /dev/null
}

make_backup() {
   tar czf $BACKUPSOURCE $TMPROOTBACKUP/* 2> /dev/null
}

send_backup() {
   USER=""
   HOST=""
   LOCATION=""

   PARAMETERS=" "$USER"@"$HOST":"$LOCATION

   rsync -azq $BACKUPSOURCE $PARAMETERS
}

clean_up() {
   rm -rf $TMPROOTBACKUP
}

printvars() {
   echo "tmprootbackup: "$TMPROOTBACKUP
   echo
   echo "logicalcompressed: "$LOGICALCOMPRESSED
   echo
   echo "varwwwcompressed: "$WWWCOMPRESSED
   echo "vargitcompressed: "$GITCOMPRESSED
   echo
   echo "backupsource: "$BACKUPSOURCE
}

# main -------------------------------------------------------------------------
if not_running_as_root; then exit 1; fi

logical_backup
phisical_backup
make_backup
#send_backup
printvars
clean_up
