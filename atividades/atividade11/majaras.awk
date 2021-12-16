BEGIN{
i=0
v[1,2,3,4,5,6]=0
}
{
        while(i <= NR){
                if(($2 == "Redes") && ($3 > v[1])){
                        v[1]=$3
                        v[4]=$1
                }else if(($2 == "Engenharia") && ($3 > v[2])){
                        v[2]=$3
                        v[5]=$1
                }else if(($2 == "Sistemas") && ($3 > v[3])){
                        v[3]=$3
                        v[6]=$1
                }else{}
                i++
        }
}
END{ print "Engenharia: " v[5] ", " v[2] "\nRedes: " v[4] ", " v[1] "\nSistemas: " v[6] ", " v[3] }
