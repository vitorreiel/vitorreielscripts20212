#!/bin/bash
# Correção: 2,0
SUBREDE=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text)
GRUPO=$(aws ec2 create-security-group --group-name "scriptVRML" --description "Grupo de Seguranca para Scripts" --output text)

PORT22=$(aws ec2 authorize-security-group-ingress --group-id $GRUPO --protocol tcp --port 22 --cidr 0.0.0.0/0)
PORT80=$(aws ec2 authorize-security-group-ingress --group-id $GRUPO --protocol tcp --port 80 --cidr 0.0.0.0/0)

INSTANCIA=$(aws ec2 run-instances --image-id "ami-083602cee93914c0c" --instance-type t2.micro --key-name $1 --region us-east-1 --security-group-ids $GRUPO --subnet-id $SUBREDE --user-data file://instalacaoSV.sh --query "Instances[0].InstanceId" --output text)

echo "Criando servidor de Monitoramento em CRON... Por favor, Aguarde."

while [[ $STATUS != "running" ]]; do
	sleep 2
	STATUS=$(aws ec2 describe-instances --instance-id $INSTANCIA --query "Reservations[0].Instances[0].State.Name" --output text)
done

echo 'Instância em estado "'$STATUS'"'
IP=$(aws ec2 describe-instances --instance-id $INSTANCIA --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
echo "Acesse: http://"$IP"/"
