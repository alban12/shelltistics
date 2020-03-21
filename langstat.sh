#!/bin/bash

if [ $# -eq 1 ] && [ -f $1 ] && [ ! -z $1 ] #Verify there's a parameter and that it is a file 
then
	for lettre in {A..Z} 
		do
			echo "$(grep $lettre $1 | wc -w) - $lettre" #Count the number of times the number appears in the file 
		done | sort -hr 
elif [ $# -eq 2 ] && [ -f $1 ] && [ $2 = "--position" ] #second option that gives statistics of position for each letter 
then 
	for lettre in {A..Z} 
		do
			declare -ai positions=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) #We declare a tab of size 25 (Longest possible word in french) to count the number of times a letter that is treated appears at each position 
			for line in $(grep $lettre $1) #We go through every words containing the letter treated 
			do
				for i in `seq 0 ${#line}` #We go through every letter of the words to get their position
				do 
					lettredumot="${line:$i:1}" #We get every letter of the word to compare it with the current treated letter 
					if [ "$lettredumot" = $lettre ] 
					then 
						let positions[i]++; #We indicate that the letter appear at the position i by incrementing it in the table 
					fi  
				done
			done

			#We now compare the the cases of the table to determine the max (the position in which the letter has appeared the most) and the number of times it has

			max=${positions[0]} #We initialise the max to the first element of the tab to compare it with the rest
			i=0; #i will keep the number of the numbre of the case in the table traversal 
			indicemax=1; #indicemax keep the index in which the max is 
			for n in "${positions[@]}" ; do
			let i++;  
    			((n > max)) && max=$n && indicemax=$i #If the value of position[i] is gt max, we set it as the new max and it is in this therefore in the position i that the letter appear the most so we affect it to indicemax 
			done
			position="la lettre $lettre apparait le plus souvent à la position : $indicemax et ce, dans $max mots "
			echo "$(grep $lettre $1 | wc -w) - $lettre - $position"	
		done | sort -hr
elif  [ $# -eq 2 ] && [ -f $1 ] && [ $2 = "--inverse" ] #Another option that inverse the way the command is printed
then 
	for lettre in {A..Z} 
		do
			echo "$(grep $lettre $1 | wc -w) - $lettre" 
		done | sort -h 
else
	echo "langstat: impossible d'accéder à $1: aucun fichier de ce type ou paramètres non définies"
fi


