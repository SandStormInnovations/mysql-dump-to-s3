#!/bin/bash
#===============================================================================
#
# FILE: mysql-dump-to-s3.sh
#
# USAGE: mysql-dump-to-s3.sh  [-u username] \
#                             [-p password] \
#                             [-h hostname] \
#                             [-b bucket]   \
#                             [-d database]
#
# DESCRIPTION:  Dump a single MySQL database or all MySQL databases on a single
#               host.  Compress tarballs.  Upload tarballs to a specified bucket
#               on Amazon S3.
#
# BASED ON: script by Devon Schreiner
#
# REQUIREMENTS: s3cmd (http://github.com/s3tools/s3cmd) must be installed and
#               configured with sufficient privileges to put a file in the
#               specified bucket.
#
# AUTHOR: Jordan B. Sanders, jordan@SandStormIT.com, http://jordanbsanders.com
# COMPANY: SandStormIT
# VERSION: 0.1
#===============================================================================

# Parse parameters
while getopts u:p:h:b:d: opt
do
  case "${opt}" in
  u) USER=${OPTARG};;
  p) PASSWORD=${OPTARG};;
  h) HOST=${OPTARG};;
  b) BUCKET=${OPTARG};;
  d) DATABASE=${OPTARG};;
  esac
done

# List Databases to Dump
if [[ -z "$DATABASE" ]] then
  DBS="$(mysql -u $USER -h $HOST -p$PASSWORD -Bse 'show databases')"
else
  DBS="$DATABASE"
fi

for db in $DBS
  do
  DMPFILE="$db"_$(date +"%Y%m%d").sql
  BACKUPFILE="$db"_$(date +"%Y%m%d").tgz

  # Dump Database
  mysqldump -u $USER -h $HOST -p$PASSWORD $db > $DMPFILE

  # Compress Dump
  tar czf $BACKUPFILE $DMPFILE

  # Upload Tarball
  MONTH=$(date +"%Y%m")
  sudo s3cmd put $BACKUPFILE s3://$BUCKET/$MONTH/$BACKUPFILE

  # Delete Local Dump and Tarball
  sudo rm $DMPFILE $BACKUPFILE
done
