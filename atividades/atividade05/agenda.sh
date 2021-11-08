#!/bin/bash
# Correção: 1,5
case $1 in adicionar)
	if [ -e agenda.db ]; then
		echo "Usuário $2 adicionado." && echo $2:$3 >> agenda.db
	else
		echo -e "Arquivo criado!!! \nUsuário $2 adicionado." && echo $2:$3 >> agenda.db
	fi;;
listar)
	if [ "$(grep -i : agenda.db)" ]; then
		cat agenda.db
	else
		echo "Arquivo vazio!!!"
	fi;;
remover)
	n=$(grep -B 0 :$2 agenda.db)
	if [ "$n" ]; then
	  	echo "Usúario '$n' removido." & sed -i "s/$n//g" agenda.db
	else
		echo "O email informado '$2' não existe!"
	fi;;
esac
