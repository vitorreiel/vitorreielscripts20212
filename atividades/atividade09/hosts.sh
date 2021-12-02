#!/bin/bash
while getopts "a:d:l:i:r" arg; do
	n=$(grep -i $2 hosts.db)
	case $arg in a)
		#adicionar o nome da maquina
		echo $2 | tr -d '\n' >> hosts.db;;
	i)
		#adicionar o IP da maquina
		echo " $4" >> hosts.db;;
	l)
		#listar todas as maquinas e seus IP's
		cat hosts.db;;
	d)
		#remover máquina e seu IP, caso exista.
		if [ "$n" ]; then
			sed -i "s/$n//g" hosts.db
		else
			echo "O hostname '$2' não está cadastrado!"
		fi;;
	r)
		#mostrar o hostname do IP recebido, caso exista.
		if [ "$n" ]; then
			grep -B 0 $2 hosts.db | egrep -o '\w+' | head -1
		else
			echo "O IP '$2' não está associado a nenhum hostname!"
		fi;;
	*)
		#mostrar o IP do hostname recebido, caso exista.
		if [ "$1" ]; then
			grep -A 0 $1 hosts.db | sed 's/ /\n/g' | head -2 | tail -1
		else
			echo "O hostname '$1' não está associado a nenhum IP!"
		fi;;
	esac
done
