#!/bin/bash

#Generic vars for later
INSTALLPATH="/Library/WebServer/Documents"

#This is the local user you're logged in as
#Only needed if you're going to use WP CLI
USER="LOCALUSER"

#DB vars needed for later
DBHOST="127.0.0.1"
DBUSER=""
DBPASS=""

#WordPress vars needed for later
WPUSER=""
WPPASS=""
WPTITLE=""

echo -e "Please provide an install name."
read installname

mkdir $INSTALLPATH/$installname
mkdir $INSTALLPATH/$installname/public_html
mkdir $INSTALLPATH/$installname/logs

chmod -R 755 $INSTALLPATH/$installname

echo -e "Please provide the dev domain"
read devdomain

echo -e "127.0.0.1	$devdomain" >> /etc/hosts

echo "Let's begin creating your vhost file now."

echo -e "Please enter the ServerAdmin's email address"
read serveradmin

touch /etc/apache2/other/httpd-$installname.conf
echo -e "<VirtualHost *:80>
	ServerAdmin $serveradmin
        DocumentRoot \"$INSTALLPATH/$installname/public_html\"
        ServerName $devdomain
	ServerAlias www.$devdomain
	ErrorLog $INSTALLPATH/$installname/logs/error_log
	CustomLog \"$INSTALLPATH/$installname/logs/access_log\" common
</VirtualHost>" >> /etc/apache2/other/httpd-$installname.conf

echo "Finished created your vhost file."

echo "Do we need to create a database for this install?"
read cdb
if [ $cdb == 'yes' ]; then
	mysqladmin -u$DBUSER -p$DBPASS create wp_$installname
fi

echo "Are you wanting to create a fresh install with WP-CLI?"
read usewpcli
if [ $usewpcli == 'yes' ]; then
	#without this, download failed for me. Remove at your own risk
	chmod -R 777 $INSTALLPATH/$installname
	
	#Running this as sudo barks an error, so we need to tell sudo to use the local user
	sudo -u $USER -i -- wp core download --path=$INSTALLPATH/$installname/public_html	
	
	#Create the wp-config.php file
	sudo -u $USER -i -- wp core config --path=$INSTALLPATH/$installname/public_html --dbhost=$DBHOST --dbname=wp_$installname --dbuser=$DBUSER --dbpass=$DBPASS
	
	#Install WordPress
	sudo -u $USER -i -- wp core install --path=$INSTALLPATH/$installname/public_html --url=http://$devdomain --title=$WPTITLE --admin_user=$WPUSER --admin_password=$WPPASS --admin_email=$serveradmin	

	echo "WordPress installation complete."
fi

apachectl restart
echo "Your local install has been completed."
