#!/bin/bash
# Correção: 0,5. Não ordenou a saída. Veja o arquivo de ips que atualizei.
echo "Aguarde um momento... Isso pode demorar um pouquinho."
for i in {1..5}; do
	array[i]=$(sed -n $[i]p enderecos_ip.txt)
	ping -c 10 ${array[i]} | sed -n '/^rtt/p' | cut -f5 -d'/' >> teste.txt
	echo $( echo ${array[i]} & sed -n $[i]p teste.txt )"ms" >> teste2.txt
	if [ $i == 3 ]; then
		echo "Quase lá... Calma Calma."
	fi
done
sort teste2.txt
rm teste.txt teste2.txt
