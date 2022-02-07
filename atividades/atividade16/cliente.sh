#!/bin/bash
amazon-linux-extras install -y php7.2
yum install -y httpd mariadb
systemctl start mariadb
systemctl enable mariadb
service httpd start
systemctl enable httpd
echo -e "[client]\nuser="vitor"\npassword="lima > /home/ec2-user/.my.cnf
wget -c -P /home/ec2-user https://wordpress.org/latest.tar.gz
mkdir /var/www/html/wordpress
cd /home/ec2-user
tar -xzf latest.tar.gz
echo -e "<?php\ndefine( 'DB_NAME', 'scripts' );\ndefine( 'DB_USER', 'vitor' );\ndefine( 'DB_PASSWORD', 'lima' );\ndefine( 'DB_HOST', '172.31.6.153' );\ndefine( 'DB_CHARSET', 'utf8' );\ndefine( 'DB_COLLATE', '' );\n$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)\n\$table_prefix= 'wp_';\ndefine( 'WP_DEBUG', false );\nif ( ! defined( 'ABSPATH' ) ) {define( 'ABSPATH', __DIR__ . '/' );}\nrequire_once ABSPATH . 'wp-settings.php';" > /home/ec2-user/wordpress/wp-config.php
cp -r /home/ec2-user/wordpress/* /var/www/html/wordpress/
service httpd restart
