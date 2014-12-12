#!/bin/bash
#
#	Author:
#		Felipe Mariani Lopes <bolzin [at] gmail [dot] com>
#
# Program:
#		analize.sh
#
# Usage:
#		sudo ./analize.sh [--invalid [-i|-u]| --root]
#
# Description:
#		This program examines /var/log/auth.log files looking for
#		suspicious attempts to log into server. It examines root
#		attempts, invalid users and output the source ips.
# ------------------------------------------------------------------------------

# Settings - You can change the setting according your configuration
CURRENT="/var/log/auth.log /var/log/auth.log.1"
COMPACTED="/var/log/auth.log.[[:digit:]].gz"

# to show only the last attempts, you can use this line
#AUTHLOG="$CURRENT"
AUTHLOG="$CURRENT $COMPACTED"

# Temporary files used during execution
TEMP=$(tempfile)
RESULTTEMP=$(tempfile)

function attempts()
{
	# used to decide between cat and zcat
	extension="${1##*.}"

	case "$2" in
		# list all ips that tried to log in as root
		--root)
			if [ "$extension" = 'gz' ]
			then
				zcat $1 |\
				tr -s " " |\
				grep "Failed password for root" |\
				cut -d" " -f11 >> $RESULTTEMP

			else
				cat $1 |\
				tr -s " " |\
				grep "Failed password for root" |\
				cut -d" " -f11 >> $RESULTTEMP
			fi
			;;

		# list invalid users or invalid users' ip
		--invalid)
			if [ "$extension" = 'gz' ]
			then
				zcat $1 |\
				tr -s " " |\
				grep "Failed password for invalid user" |\
				cut -d" " -f11,13 > "${TEMP}"
			else
				cat $1 |\
				tr -s " " |\
				grep "Failed password for invalid user" |\
				cut -d" " -f11,13 > "${TEMP}"
			fi

			case "$3" in
				-u)
					cat $TEMP | cut -d" " -f1 >> "${RESULTTEMP}"
					;;
				-i)
					cat $TEMP | cut -d" " -f2 >>  "${RESULTTEMP}"
					;;
			esac
			;;
	esac
}

# main
for file in $AUTHLOG;
do
	attempts $file $1 $2
done

# I'm using sort twice here because it is not sorting correctly when called once
cat $RESULTTEMP | sort | uniq -c | tr -s " " | cut -c2- | sort -n -k1 -r 

# removing temporary files
rm $TEMP
rm $RESULTTEMP

