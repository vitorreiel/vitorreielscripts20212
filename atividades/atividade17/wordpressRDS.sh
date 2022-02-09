#!/bin/bash
# pegando a lista de SUBREDE disponivel, criando o grupo de segurança e ainda, criando uma DB-SUBNET, para caso o usuario não possua uma em sua AWS.
SUBREDE0=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text)
SUBREDE1=$(aws ec2 describe-subnets --query 'Subnets[1].SubnetId' --output text)
SUBREDE2=$(aws ec2 describe-subnets --query 'Subnets[2].SubnetId' --output text)
GRUPO=$(aws ec2 create-security-group --group-name "scriptsVRML" --description "Grupo de Seguranca para Scripts" --output text)
DBSUBNET=$(aws rds create-db-subnet-group --db-subnet-group-name "db-subnet-vrml" --db-subnet-group-description "DB Subnet Scripts" --subnet-ids $SUBREDE0 $SUBREDE1 $SUBREDE2 --output text)
DBSN=$(aws rds describe-db-subnet-groups --query 'DBSubnetGroups[0].DBSubnetGroupName' --output text)



# pegando o ip publico e liberando as portas 22, 80 e 3306
IPG=$(wget -qO- http://ipecho.net/plain)
PORT22=$(aws ec2 authorize-security-group-ingress --group-id $GRUPO --protocol tcp --port 22 --cidr $IPG/32)
PORT80=$(aws ec2 authorize-security-group-ingress --group-id $GRUPO --protocol tcp --port 80 --cidr 0.0.0.0/0)
PORT3306=$(aws ec2 authorize-security-group-ingress --group-id $GRUPO --protocol tcp --port 3306 --source-group $GRUPO)



# criando o banco de dados RDS e fazendo a verificação de status para prosseguir, apenas quando estiver disponível.
echo "Criando instância de Banco de Dados no RDS... Isso vai demorar, por favor aguarde..."
RDS=$(aws rds create-db-instance --db-instance-identifier scripts --engine mariaDB --master-username $2 --master-user-password $3 --allocated-storage 20 --no-publicly-accessible --db-subnet-group-name $DBSN --vpc-security-group-ids $GRUPO --db-instance-class 'db.t2.micro' --output text)

while [[ $RDS_STATUS != "available" ]]; do
	sleep 2
	RDS_STATUS=$(aws rds describe-db-instances --query "DBInstances[0].DBInstanceStatus" --output text)
done
ENDPOINT=$(aws rds describe-db-instances --query "DBInstances[0].Endpoint.Address" --output text)
echo "Endpoint do RDS: "$ENDPOINT


# criando arquivo para instalar e configurar o cliente do MySQL, criar a database wordpress, criar um usuario e dar privilegios a ele e por fim, fazer a instalação e configuração do arquivo wordpress.
echo "Criando servidor de Aplicação... Aguarde..."
cat<<EOF >  cliente.sh
#!/bin/bash
amazon-linux-extras install -y php7.2
yum install -y httpd mariadb
systemctl start mariadb
systemctl enable mariadb
service httpd start
systemctl enable httpd
echo -e "[client]\nuser="$2"\npassword="$3 > /root/.my.cnf
echo -e "[client]\nuser="$2"\npassword="$3 > /home/ec2-user/.my.cnf
echo -e "sudo mysql -u "$2" -h "$ENDPOINT"<<EOF\nCREATE DATABASE wordpress;\nCREATE USER '"$2"'@'%' IDENTIFIED BY '"$3"';\nGRANT ALL PRIVILEGES ON wordpress.* TO '"$2"'@'%';\nUSE wordpress;\nEOF\nrm /home/ec2-user/wordpress.sh" > /home/ec2-user/wordpress.sh
chmod +x /home/ec2-user/wordpress.sh
cd /home/ec2-user
./wordpress.sh
wget -c -P /home/ec2-user https://wordpress.org/latest.tar.gz
mkdir /var/www/html/wordpress
tar -xzf latest.tar.gz
echo -e "<?php\ndefine( 'DB_NAME', 'wordpress' );\ndefine( 'DB_USER', '$2' );\ndefine( 'DB_PASSWORD', '$3' );\ndefine( 'DB_HOST', '$ENDPOINT' );\ndefine( 'DB_CHARSET', 'utf8' );\ndefine( 'DB_COLLATE', '' );\n\$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)\n\\\$table_prefix= 'wp_';\ndefine( 'WP_DEBUG', false );\nif ( ! defined( 'ABSPATH' ) ) {define( 'ABSPATH', __DIR__ . '/' );}\nrequire_once ABSPATH . 'wp-settings.php';" > /home/ec2-user/wordpress/wp-config.php
cp -r /home/ec2-user/wordpress/* /var/www/html/wordpress/
service httpd restart
EOF



# criando a segunda instancia e fazendo a verificação de status da máquina, em seguida liberar o IP público, apenas quando o servidor wordpress estiver online.
INSTANCIA=$(aws ec2 run-instances --image-id "ami-0533f2ba8a1995cf9" --instance-type t2.micro --key-name $1 --region us-east-1 --security-group-ids $GRUPO --subnet-id $SUBREDE0 --user-data file://cliente.sh --query "Instances[0].InstanceId" --output text)
while [[ $STATUS != "running" ]]; do
        sleep 2
        STATUS=$(aws ec2 describe-instances --instance-id $INSTANCIA --query "Reservations[0].Instances[0].State.Name" --output text)
done

IP=$(aws ec2 describe-instances --instance-id $INSTANCIA --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

while [[ $ON != "HTTP" ]]; do
        sleep 2
        ON=$(curl -Is http://$IP/wordpress/ | sed 's/\//\n/g' | head -1)
done

echo "IP Público do Servidor de Aplicação: "$IP
echo -e "\nAcesse  http://"$IP"/wordpress  para finalizar a configuração."
