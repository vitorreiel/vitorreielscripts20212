#!/bin/bash
# Correção: 1,0
mkdir cinco
cd cinco
for i in {1..5}; do
	mkdir dir$[i]
	cd dir$[i]
	for l in {1..4}; do
		case $l in 1)
			echo -e "1" > arq$[l].txt;;
		2)
			echo -e "2\n2" > arq$[l].txt;;
		3)
			echo -e "3\n3\n3" > arq$[l].txt;;
		4)
			echo -e "4\n4\n4\n4" > arq$[l].txt
			cd ..;;
		esac
	done
done
echo "Diretórios criados com sucesso!"
