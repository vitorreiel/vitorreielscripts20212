#!/bin/bash
# Correção: 1,0
#A primeira execução do script ele faz apenas uma verificação.
dt=$(date +%d-%m-%G && date +%X)
n=0
cd $2
ls . > ../teste.txt
cd ..
while true; do
	f=$(cd $2 && ls | wc -l)
	m=$(cd $2 && ls -t | head -1)
	cd $2
	ls . > ../historico.txt
	cd ..
	if [ $f -gt $n ]; then
		t=$(diff teste.txt historico.txt | grep ^\> )
		echo "["$dt"] Alteração!" $n"->"$f". Adicionados" $t | tee -a dirSensors.log
	else
		if [ $f -lt $n ]; then
			r=$(diff historico.txt teste.txt | grep ^\> )
			echo "["$dt"] Alteração!" $n"->"$f". Removidos" $r | tee -a dirSensors.log
		fi
	fi
	cat historico.txt > teste.txt
	n=$f
 	sleep $1;
done
