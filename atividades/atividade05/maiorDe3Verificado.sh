#!/bin/bash
m=0
n=0
array[1]=$1
array[2]=$2
array[3]=$3
for i in {1..3}; do
	if [ ${array[i]} -gt 0 -o ${array[i]} -lt 0 ]; then
		if [ ${array[i]} -gt $m ]; then
			m=${array[i]}
		fi
	else
		echo "OPAAAA '${array[i]}' não é um númmero!"
		n=1
	fi
done
if [ $n -eq 0 ]; then
	echo $m 'é o maior valor'
fi
