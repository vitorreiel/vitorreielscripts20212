#!/bin/bash
# Correção: 0,0

TECLA=
VISOR=

until [ "$TECLA" = "q" ]
do
   clear
   tput cup 0 10
   printf "TELA: $VISOR"
   tput cup 1 10
   printf "%d %d %d" 1 2 3
   tput cup 2 10
   printf "%d %d %d" 4 5 6
   tput cup 3 10
   printf "%d %d %d" 7 8 9
   tput cup 4 10
   printf "%c %c %c %c" + - \* /
   tput cup 5 10

   # Ler a entrada do usuário
   read TECLA

   # Se já tiver alguma operação na tela, apague
   if [[ $VISOR =~ .*=.* ]]
   then
      VISOR=
   fi




   # se você digitou um número
   if [[ $TECLA =~ [0-9]+ ]]
   then
       # e ainda não tem nada na tela
       if [ ! "$VISOR" ]
       then
          # coloque o número na tela
          VISOR=$TECLA
       else
          # e já existe um número e um operador na tela
          if [[ $VISOR =~ [0-9]+[[:blank:]][*/\+\-] ]]
          then



             # faça a operação
             expressao=$(printf "expr %s %s" "$VISOR" "$TECLA" | sed 's/\*/\\*/g')
             resultado=`eval "$expressao"`
             VISOR="$VISOR $TECLA = $resultado"



          fi
       fi





   # se você não digitou um número
   else
       # mas digitou um operador
       if [[ $TECLA =~ [*/\+\-] ]]
       then
          # atualize a tela para mostrar o primeiro número e o operador
          VISOR="$VISOR $TECLA"
       fi
   fi

done
