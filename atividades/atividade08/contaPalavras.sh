#!/bin/bash

echo -ne 'Informe o arquivo: \e :'
read arq
cat $arq | egrep -o '\w+' | sort | uniq -c | sort -n -r
