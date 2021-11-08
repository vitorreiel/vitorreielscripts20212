#!/bin/bash
<<<<<<< HEAD
=======
# Correção: 2,0
>>>>>>> 5a26045d2fbd011ec56de07858e5362e859b75ab
d=$(date +%d)
m=$(date +%m)
a=$(date +%G)
u=$USER
echo -e 'Olá' $u',\nHoje é dia '$d', do mês '$m' do ano de '$a'.' | tee -a saudacao.log
