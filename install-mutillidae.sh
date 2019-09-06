#!/bin/bash

# Works only in Ubuntu. Highly recommended to set this up on a VM. 
# Once Mutillidae is installed, the network configuration should be changed to host-only on the VM Host. 
# This webserver is extremely vulnerable and shouldn't be available network wide.
# Script created Sept 4th, 2019

# Copyright (C) 2019 drifter666
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


# Update the OS and install LAMP Server
echo -e "Task #1: Updating and installing LAMP-Server. Might take a few mins...\n"
sudo apt-get update > /dev/null
sudo apt-get dist-upgrade -y > /dev/null
sudo apt-get install tasksel -y > /dev/null
sudo tasksel install lamp-server > /dev/null
echo -e "Task #1: Done!\n"

# Add additional packages for Mutillidae to work
echo -e "Task #2: Installing additional packages needed for Mutillidae...\n"
sudo apt-get install php-xml php-fpm libapache2-mod-php php-mysql php-xml php-gd php-imap php-mysql php-gettext php-curl -y > /dev/null
sudo a2enmod proxy_fcgi setenvif > /dev/null
sudo a2enconf php7.2-fpm > /dev/null
echo -e "Task #2: Done!\n"

# The next line is very dangerous, it allows anyone to connect to all databases with no restriction without a username and password. 
echo -e "Task #3: Adding skip-grant-tables to mysqld.cnf. Remember, this leaves a giant hole in MySQL...\n"
echo 'skip-grant-tables' | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null
echo -e "Task#3: Done!\n

# Restart the services to accept the changes
echo -e "Task #4: Restarting all the services...\n"
sudo systemctl reload apache2 > /dev/null
sudo systemctl restart apache2 > /dev/null
sudo systemctl restart mysql > /dev/null
echo -e "Task #4: Done!\n"

# Install mutillidae
echo -e "Task #5: Cloning Mutillidae from github and setting correct owner permissions\n"
sudo mkdir /var/www/html/mutillidae > /dev/null
git clone https://github.com/webpwnized/mutillidae.git /var/www/html/mutillidae > /dev/null
sudo chown www-data:www-data -R /var/www/html/mutillidae > /dev/null
echo -e "Task #5: Done!\n"


