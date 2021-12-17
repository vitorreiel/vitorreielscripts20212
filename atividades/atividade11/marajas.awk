{salario[$2]=$1 ": " $3}
END{
for (prof in salario) {
                print salario[prof] ", " prof
        }
}
