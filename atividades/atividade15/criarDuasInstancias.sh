#!/bin/bash
# pegando a SUBREDE disponivel e criando o grupo de segurança
SUBREDE=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text)
GRUPO=$(aws ec2 create-security-group --group-name "scriptsVRML" --description "Grupo de Seguranca para Scripts" --output text)


# pegando o ip publico e liberando as portas 22, 80 e 3306
IPG=$(wget -qO- http://ipecho.net/plain)
PORT22=$(aws ec2 authorize-security-group-ingress --group-id $GRUPO --protocol tcp --port 22 --cidr $IPG/32)
PORT80=$(aws ec2 authorize-security-group-ingress --group-id $GRUPO --protocol tcp --port 80 --cidr 0.0.0.0/0)
PORT3306=$(aws ec2 authorize-security-group-ingress --group-id $GRUPO --protocol tcp --port 3306 --source-group $GRUPO)


# criando arquivo para instalar e configurar servidor MySQL
cat<<EOF > servidor.sh
#!/bin/bash
yum install -y mariadb-server
systemctl start mariadb
systemctl enable mariadb
echo -e "mysql<<EOF\nCREATE DATABASE scripts;\nCREATE USER '"$2"'@'%' IDENTIFIED BY '"$3"';\nGRANT ALL PRIVILEGES ON scripts.* TO '"$2"'@'%';\nUSE scripts;\nEOF\nrm /home/ec2-user/scripts.sh" > /home/ec2-user/scripts.sh
chmod +x /home/ec2-user/scripts.sh
cd /home/ec2-user
./scripts.sh
EOF



# criando a primeira instancia e fazendo a verificação de status da máquina, logo depois imprimir o IP Privado na tela
INSTANCIA=$(aws ec2 run-instances --image-id "ami-0533f2ba8a1995cf9" --instance-type t2.micro --key-name $1 --region us-east-1 --security-group-ids $GRUPO --subnet-id $SUBREDE --user-data file://servidor.sh --query "Instances[0].InstanceId" --output text)
echo "Criando servidor de Bando de Dados... Por favor, Aguarde."

while [[ $STATUS != "running" ]]; do
        sleep 2
        STATUS=$(aws ec2 describe-instances --instance-id $INSTANCIA --query "Reservations[0].Instances[0].State.Name" --output text)
done

IP1=$(aws ec2 describe-instances --instance-id $INSTANCIA --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
echo "IP Privado do Banco de Dados: "$IP1


# criando arquivo para instalar e configurar o cliente do MySQL e adicionar a Tabela Teste
cat<<EOF >  cliente.sh
#!/bin/bash
yum install -y mariadb mariadb-server
systemctl start mariadb
systemctl enable mariadb
echo -e "[client]\nuser="$2"\npassword="$3 > /root/.my.cnf
echo -e "[client]\nuser="$2"\npassword="$3 > /home/ec2-user/.my.cnf
echo -e "sudo mysql -u "$2" scripts -h "$IP1"<<EOF\nUSE scripts;\nCREATE TABLE Teste ( atividade INT );\nEOF\nrm /home/ec2-user/scripts.sh" > /home/ec2-user/scripts.sh
chmod +x /home/ec2-user/scripts.sh
cd /home/ec2-user
./scripts.sh
EOF


# criando a segunda instancia e fazendo a verificação de status da máquina
INSTANCIA2=$(aws ec2 run-instances --image-id "ami-0533f2ba8a1995cf9" --instance-type t2.micro --key-name $1 --region us-east-1 --security-group-ids $GRUPO --subnet-id $SUBREDE --user-data file://cliente.sh --query "Instances[0].InstanceId" --output text)
echo "Criando servidor de Aplicação... Por favor, Aguarde."

while [[ $STATUS2 != "running" ]]; do
        sleep 2
        STATUS2=$(aws ec2 describe-instances --instance-id $INSTANCIA2 --query "Reservations[0].Instances[0].State.Name" --output text)
done

sleep 30
IP2=$(aws ec2 describe-instances --instance-id $INSTANCIA2 --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
echo "IP Público do Servidor de Aplicação: "$IP2
