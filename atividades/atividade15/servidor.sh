#!/bin/bash
yum install -y mariadb-server
systemctl start mariadb
systemctl enable mariadb
echo -e "mysql<<EOF\nCREATE DATABASE scripts;\nCREATE USER '"joaomarcelo"'@'%' IDENTIFIED BY '"1566scripts"';\nGRANT ALL PRIVILEGES ON scripts.* TO '"joaomarcelo"'@'%';\nUSE scripts;\nEOF\nrm /home/ec2-user/scripts.sh" > /home/ec2-user/scripts.sh
chmod +x /home/ec2-user/scripts.sh
cd /home/ec2-user
./scripts.sh
