# Correção: 0,0. Não fez nenhuma comparação para descobrir o maior salário. Tudo OK no AWS Academy.
{salario[$2]=$1 ": " $3}
END{
for (prof in salario) {
                print salario[prof] ", " prof
        }
}
