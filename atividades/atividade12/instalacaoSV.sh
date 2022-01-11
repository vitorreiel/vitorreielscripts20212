#!/bin/bash
sudo yum install -y httpd
sudo systemctl start httpd
echo "<html><h1>Vitor Reiel Moura de Lima<p>499077</p></h1></html>" > /var/www/html/index.html
