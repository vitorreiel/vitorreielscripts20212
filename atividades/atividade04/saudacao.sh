d=$(date +%d)
m=$(date +%m)
a=$(date +%G)
u=$USER
n=$(echo 'Olá' $u',\nHoje é dia '$d', do mês '$m' do ano de '$a'.')
echo -e "$n"
echo -e "$n" >> saudacao.log
