#!/bin/bash
sudo yum install -y mariadb mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
echo -e "[client]\nuser="vitor"\npassword="limaa > /home/ec2-user/.my.cnf
echo -e "(mysql -u '"vitor"' scripts -h '"172.31.15.144"')<<EOF\nUSE scripts;\nCREATE TABLE Teste ( atividade INT );\nEOF\nrm /home/ec2-user/scripts.sh" > /home/ec2-user/scripts.sh
sudo chmod +x /home/ec2-user/scripts.sh
cd /home/ec2-user
./scripts.sh
