#!/bin/sh

path="Makefile"

#Test d'argument
if test $# -gt 0
then
	if [ ! -d $1 ]
	then
		echo $1" n'est pas un dossier ou n'existe pas"
		exit 0
	else
		slash=$(echo "$1" | grep -c '\/$')
		if [ $slash -gt 0 ]
		then
			path1=$1
		else
			path1=$1"/"
		fi
	fi
fi

path=$path1$path

#Savoir si le Makefile est déjà présent

present="non"

for fichier in `ls $1`
do
	if [ "$fichier" = "Makefile" ]
	then
		present="oui"
	fi
done

if [ $present = "non" ]
then
	echo -e 'CFLAGS= -g -Wall\nPROGS=\n\nall: $(PROGS)\n\nclean: \n\trm *.o *~ $(PROGS)\n\n' > $path
fi

continue="oui"

while [ "$continue" = "oui" ]
do
	echo "Entrez le nom du programme"
	read fic
	
	fic=$(echo "$fic" | sed 's/\ /_/') #Remplacer les espaces par _
	c1=$(echo "$fic" | grep -c '^\w\w*') #Validation du nom
	c2=$(grep -c "\ $fic\." $path) #Savoir si le nom est déjà pris
	
	if [ $c1 -gt 0 ]
	then
		if [ $c2 -eq 0 ]
		then
			continue="non"
		else
			echo "Nom déjà pris"
		fi
	fi
done

ligne=$(grep "^PROGS=" $path) #Rechercher la ligne avec PROGS=

ligne2=$ligne$fic" "

sed -i "s/$ligne/$ligne2/g" $path #La compléter avec le nouveau programme

CODE[0]=$fic

continue="oui"

while [ "$continue" = "oui" ]	
do
	echo "Combien de dépendances ?"
	read n
	
	c=$(echo "$n" | grep -c '^[0-9][0-9]*')
	if [ $c -gt 0 ]
	then
		continue="non"
	fi
done

for (( i=1; i <= n; i++ ))
do	
	continue="oui"

	while [ "$continue" = "oui" ]
	do
		echo "Dépendances "$i
		read fic

		fic=$(echo "$fic" | sed 's/\ /_/')
		c1=$(echo "$fic" | grep -c '^\w\w*')
		c2=$(grep -c "\ $fic\." $path)
	
		if [ $c1 -gt 0 ]
		then
			if [ $c2 -eq 0 ]
			then
				continue="non"
			else
				echo "Nom déjà pris"
			fi
		fi
	done
	
	CODE[$i]=$fic
done

line=${CODE[0]}": " #Dépendances (.o) du programme

for (( i=0; i <= n; i++ ))
do
	line=$line${CODE[$i]}".o " #On ajoute les .o
done

echo -e $line"\n" >> $path #On copie le tout

main=${CODE[0]}".o: "${CODE[0]}".c" #Dépendances (.h et .c) du programme.o
ajoutmain=$main" "

for (( i=0; i <= n; i++ ))
do
	line=${CODE[$i]}".o: "${CODE[$i]}".c " #Dépendances (.c) des dépendances.o
	
	if [ $i -gt 0 ]
	then
		line=$line${CODE[$i]}".h " #On leur rajoute les .h
		ajoutmain=$ajoutmain${CODE[$i]}".h " #On les rajoute aussi au programme.o
	fi
	
	echo -e $line >> $path
done

echo -e "\n" >> $path

sed -i "s/$main/$ajoutmain/g" $path #On remplace par la ligne avec ses dépendances .h et .c

#Ecriture des fichiers .c et .h

includes="#include <stdlib.h>\n#include <stdio.h>"

if [ ! -e "$path1${CODE[0]}.c" ]
then
	prog="true"
else
	prog="false"
fi

for (( i=0; i <= n; i++ ))
do
	if [ ! -e "$path1${CODE[$i]}.c" ]
	then
		echo -e "$includes" > $path1${CODE[$i]}".c"

		if [ $i -gt 0 ]
		then
			echo -e "#include \"${CODE[$i]}.h\"\n\n" >> $path1${CODE[$i]}".c"
			if [ $prog = "true" ]
			then
				echo -e "#include \"${CODE[$i]}.h\"" >> $path1${CODE[0]}".c"
			fi
			touch $path1${CODE[$i]}".h"
		fi
	fi
done

if [ "$prog" = "true" ]
then
	echo -e "\nint main(int argc, char **argv){\n\t\n\t\n\t\n\treturn 0;\n}\n" >> $path1${CODE[0]}".c"
fi

for (( i=0; i <= n; i++ ))
do
	gedit $path1${CODE[$i]}".c" &
if [ $i -gt 0 ]
then
	gedit $path1${CODE[$i]}".h" &
fi
done

gedit $path1"Makefile" &
