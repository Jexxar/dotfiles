#!/bin/bash


stringZ=abcABC123ABCabc
echo $stringZ

echo ${#stringZ}                 
echo `expr length $stringZ`      
echo `expr "$stringZ" : '.*'`  


echo $stringZ
echo "12345678901234567890"
#       |------|
#       12345678

echo `expr match "$stringZ" 'abc[A-Z]*.2'`   # 8
echo `expr "$stringZ" : 'abc[A-Z]*.2'`       # 8

stringA="Aline Barros - Extraordinário Amor de Deus - 5. Não Me Calarei"
echo $stringA
echo "12345678901234567890"
tmpa=${stringA#*-}
tmpb=${stringA%-*}
echo $tmpa
echo $tmpb
mus=${tmpa#*-}
alb=${tmpa%-*}
#tmpf=${tmpb#*-}
art=${tmpb%-*}
echo $mus
echo $alb
echo $art
#echo $tmpf

#!/bin/bash
# paragraph-space.sh
# Ver. 2.1, Reldate 29Jul12 [fixup]

# Inserts a blank line between paragraphs of a single-spaced text file.
# Usage: $0 <FILENAME

MINLEN=60        # Change this value? It's a judgment call.
#  Assume lines shorter than $MINLEN characters ending in a period
#+ terminate a paragraph. See exercises below.

while read line  # For as many lines as the input file has ...
do
  echo "$line"   # Output the line itself.

  len=${#line}
  if [[ "$len" -lt "$MINLEN" && "$line" =~ [*{\.}]$ ]]
# if [[ "$len" -lt "$MINLEN" && "$line" =~ \[*\.\] ]]
# An update to Bash broke the previous version of this script. Ouch!
# Thank you, Halim Srama, for pointing this out and suggesting a fix.
    then echo    #  Add a blank line immediately
  fi             #+ after a short line terminated by a period.
done

exit

# http://api.openweathermap.org/data/2.5/weather?id=6322752&appid=547bbdc38bd641bef6645cd2c4bc613f&units=metric
