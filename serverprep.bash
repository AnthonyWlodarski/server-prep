#!/bin/bash
#
# Server configuration script to install lamp stack and any packages
# Anthony Wlodarski anthony@get2know.me
#
yum clean all
yum makecache

# Linux
yum install git
yum install gcc gcc-c++
yum install libuuid-devel
yum install patch
yum install make
yum install wget

# Java
cd /tmp
wget http://somesitewithjava.com/jdk-7u4-linux-x64.rpm
chmod 775 jdk-7u4-linux-x64.rpm
rpm -Uvh jdk-7u4-linux-x64.rpm
alternatives --install /usr/bin/java java /usr/java/latest/jre/bin/java 20000
alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 20000
alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 20000
alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_04/jre/bin/java 20000
alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_04/bin/javac 20000
alternatives --install /usr/bin/jar jar /usr/java/jdk1.7.0_04/bin/jar 20000
java -version
javac -version
cd -

# Apache
yum install httpd
/sbin/chkconfig httpd on
service httpd start

# Apache modules
yum install mod_ssl

# MySQL
yum install mysql mysql-server
/sbin/chkconfig  mysqld on
/sbin/service mysqld start
mysqladmin version status

# PHP
yum install php php-mysql php-devel
/sbin/service httpd restart

# Pear
yum install php-pear

# Apc Extension
yum install php-pecl-apc

# Gd
yum install php-gd

# Patch and install uuid for PECL
cd /tmp
wget http://pecl.php.net/get/uuid-1.0.2.tgz
tar -xzf uuid-1.0.2.tgz
cd uuid-1.0.2
wget -O uuid.patch "https://bugs.php.net/patch-display.php?bug_id=62009&patch=uuid-php-5-4.diff&revision=1336770499&download=1"
patch < uuid.patch
phpize
./configure
make
make install
echo "extension=uuid.so" > /etc/php.d/uuid.ini

# Node.js
cd /tmp
wget http://nodejs.tchol.org/repocfg/el/nodejs-stable-release.noarch.rpm
yum localinstall --nogpgcheck nodejs-stable-release.noarch.rpm
yum install nodejs-compat-symlinks npm
rm nodejs-stable-release.noarch.rpm

# Return to home
cd ~	

# Restart all daemons
service httpd restart
service mysqld restart
