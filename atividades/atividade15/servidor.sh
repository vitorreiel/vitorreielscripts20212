#!/bin/bash
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
echo -e "mysql<<EOF\nCREATE DATABASE scripts;\nCREATE USER '"vitor"'@'%' IDENTIFIED BY '"limaa"';\nGRANT ALL PRIVILEGES ON scripts.* TO '"vitor"'@'%';\nUSE scripts;\nEOF\nrm /home/ec2-user/scripts.sh" > /home/ec2-user/scripts.sh
sudo chmod +x /home/ec2-user/scripts.sh
cd /home/ec2-user
./scripts.sh
