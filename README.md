MySQL Dump to S3
=================

**USAGE:** mysql-dump-to-s3.sh  [-u username] [-p password] [-h hostname] [-b bucket] [-d database]

##DESCRIPTION

Dump a single MySQL database or all MySQL databases on a
single host.  Compress tarballs.  Upload tarballs to a specified bucket on
Amazon S3.

Based on a [script](http://community.spiceworks.com/scripts/show/1216-backup-mysql-to-amazon-s3) by Devon Schreiner.

##REQUIREMENTS

s3cmd (http://github.com/s3tools/s3cmd) must be installed and configured with
sufficient privileges to put a file in the specified bucket.


**AUTHOR:** Jordan B. Sanders, jordan@SandStormIT.com, http://jordanbsanders.com
