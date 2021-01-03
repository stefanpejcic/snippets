#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

pwd=$(pwd)

read -p 'wordpress_db_name [wp_db]: ' wordpress_db_name
read -p 'db_root_password [only-alphanumeric]: ' db_root_password
echo

apt-get update -y

sudo apt-get install apache2 apache2-utils -y
systemctl start apache2
systemctl enable apache2

apt-get install php libapache2-mod-php php-mysql -y

export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $db_root_password"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $db_root_password"
apt-get install mysql-server mysql-client -y

rm /var/www/html/index.*
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
rsync -av wordpress/* /var/www/html/

chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

mysql -uroot -p$db_root_password <<QUERY_INPUT
CREATE DATABASE $wordpress_db_name;
GRANT ALL PRIVILEGES ON $wordpress_db_name.* TO 'root'@'localhost' IDENTIFIED BY '$db_root_password';
FLUSH PRIVILEGES;
EXIT
QUERY_INPUT

cd /var/www/html/
sudo mv wp-config-sample.php wp-config.php
perl -pi -e "s/database_name_here/$wordpress_db_name/g" wp-config.php
perl -pi -e "s/username_here/root/g" wp-config.php
perl -pi -e "s/password_here/$db_root_password/g" wp-config.php

a2enmod rewrite
php5enmod mcrypt

apt-get install phpmyadmin -y

echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf

service apache2 restart
service mysql restart

cd $pwd
rm -rf latest.tar.gz wordpress

echo "Done!"
