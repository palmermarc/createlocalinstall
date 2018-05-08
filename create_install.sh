#!/bin/bash

#Generic vars for later
INSTALLPATH="/Library/WebServer/Documents"
USER=""
serveradmin=""

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
DEVDOMAIN=$installname.local

echo -e "Which folder should this be placed in? (stlclients,hubbard,2060digital)"
read FOLDER
mkdir $INSTALLPATH/$FOLDER/$installname
mkdir $INSTALLPATH/$FOLDER/$installname/public_html
mkdir $INSTALLPATH/$FOLDER/$installname/logs

chmod -R 777 $INSTALLPATH/$FOLDER/$installname

echo -e "127.0.0.1	$DEVDOMAIN" >> /etc/hosts

echo "Let's begin creating your vhost file now."

touch /etc/apache2/other/httpd-$installname.conf
echo -e "<VirtualHost *:80>
	ServerAdmin mapalmer@hbi.com
  DocumentRoot \"$INSTALLPATH/$FOLDER/$installname/public_html\"
  ServerName $DEVDOMAIN
	ServerAlias www.$DEVDOMAIN
	ErrorLog $INSTALLPATH/$FOLDER/$installname/logs/error_log
	CustomLog \"$INSTALLPATH/$FOLDER/$installname/logs/access_log\" common
</VirtualHost>" >> /etc/apache2/other/httpd-$installname.conf

echo "Finished created your vhost file."

apachectl restart
echo "Apache has been restarted."

echo "Do we need to create a database for this install?"
read cdb
if [ $cdb == 'yes' ]; then
	mysqladmin -u$DBUSER -p$DBPASS create wp_$installname
fi

echo "Are you wanting to create a fresh install with WP-CLI?"
read usewpcli
if [ $usewpcli == 'yes' ]; then
	#without this, download failed for me. Remove at your own risk
	chmod -R 777 $INSTALLPATH/$FOLDER/$installname

	#Running this as sudo barks an error, so we need to tell sudo to use the local user
	sudo -u $USER -i -- wp core download --path=$INSTALLPATH/$FOLDER/$installname/public_html

	chmod -R 777 $INSTALLPATH/$FOLDER/$installname

	sudo -u $USER -i -- wp core config --path=$INSTALLPATH/$FOLDER/$installname/public_html --dbhost=$DBHOST --dbname=wp_$installname --dbuser=$DBUSER --dbpass=$DBPASS

	sudo -R 777 $INSTALLPATH/$installname

	sudo -u $USER -i -- wp core install --path=$INSTALLPATH/$FOLDER/$installname/public_html --url=http://$DEVDOMAIN --title=$WPTITLE --admin_user=$WPUSER --admin_password=$WPPASS --admin_email=$serveradmin

	echo "WordPress installation complete."
fi

apachectl restart
echo "Your local install has been completed."
