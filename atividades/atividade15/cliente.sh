#!/bin/bash
yum install -y mariadb mariadb-server
systemctl start mariadb
systemctl enable mariadb
echo -e "[client]\nuser="joaomarcelo"\npassword="1566scripts > /root/.my.cnf
echo -e "[client]\nuser="joaomarcelo"\npassword="1566scripts > /home/ec2-user/.my.cnf
echo -e "sudo mysql -u "joaomarcelo" scripts -h "172.31.31.209"<<EOF\nUSE scripts;\nCREATE TABLE Teste ( atividade INT );\nEOF\nrm /home/ec2-user/scripts.sh" > /home/ec2-user/scripts.sh
chmod +x /home/ec2-user/scripts.sh
cd /home/ec2-user
./scripts.sh
