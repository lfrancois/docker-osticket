#!/bin/bash
/etc/init.d/postfix start
/etc/init.d/mysql start
mysqladmin -u root password docker42
exec /etc/init.d/apache2 start
