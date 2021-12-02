#!/bin/bash
# Correção: 0,5

echo -ne 'informe o arquivo: \e :'
read arq
cat $arq | egrep -o '\w+' | sort | uniq -c | sort -n -r
