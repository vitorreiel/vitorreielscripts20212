#!/bin/bash
# Correção: 2,0
d=$(date +%d)
m=$(date +%m)
a=$(date +%G)
u=$USER
echo -e 'Olá' $u',\nHoje é dia '$d', do mês '$m' do ano de '$a'.' | tee -a saudacao.log
