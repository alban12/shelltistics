#!/bin/bash

if [ $# -eq 1 ] && [ -f $1 ] && [ ! -z $1 ] #Vérifie qu'il y a bien un paramètre et que c'est un fichier en premier  
then
	for lettre in {A..Z} 
		do
			echo "$(grep $lettre $1 | wc -w) - $lettre" #On compte le nombre de fois que la lettre apparait dans le dico 	
		done | sort -hr 
elif [ $# -eq 2 ] && [ -f $1 ] && [ $2 = "--position" ] #2ème option qui donne des statistiques de position pour chaque lettre, mais qui prend beaucoup trop de temps pour des fichiers très gros 
then 
	for lettre in {A..Z} 
		do
			declare -ai positions=(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0) #On declare un tableau de dimension 25 (taille du mot le plus long possible) pour relever le nombre de fois que la lettre en cours de traitement apparait à chaque position  
			for line in $(grep $lettre $1) #On parcourt chaque mot contenant la lettre en cours de traitement  
			do
				for i in `seq 0 ${#line}` #On parcourt chaque lettre de chaque mot pour pouvoir relever les positions de la lettre en cours de traitement 
				do 
					lettredumot="${line:$i:1}" #On récupère chaque lettre du mot dans une variable pour la comparer avec la lettre en cours de traitement
					if [ "$lettredumot" = $lettre ] 
					then 
						let positions[i]++; #On indique que la lettre apparait à la position i en incrémentant le tableau des positions  
					fi  
				done
			done

			#On a maintenant le tableau indiquant pour chaque case (représentant une position) le nombre de fois où la lettre est apparue  

			#On va maintenant comparer les cases du tableau pour déterminer le max (position où la lettre apparait le plus) et son indice  

			max=${positions[0]} #On initialise le max au premier élément du tableau pour le comparer avec le reste du tableau
			i=0; #On crée une variable i pour garder le numéro de case dans le parcours du tableau
			indicemax=1; #On crée une variable indicemax qui va prendre l'indice dans lequel se trouve le max du tableau 
			for n in "${positions[@]}" ; do
			let i++;  
    			((n > max)) && max=$n && indicemax=$i #Si la valeur de la position[i] est supérieure au max, on la défini comme le nouveau max et c'est donc à cette position i que la lettre apparait le plus donc on l'affecte à indicemax   
			done
			position="la lettre $lettre apparait le plus souvent à la position : $indicemax et ce, dans $max mots "
			echo "$(grep $lettre $1 | wc -w) - $lettre - $position"	
		done | sort -hr
elif  [ $# -eq 2 ] && [ -f $1 ] && [ $2 = "--inverse" ] #2eme option plus simple qui se contente d'inverser l'affichage  
then 
	for lettre in {A..Z} 
		do
			echo "$(grep $lettre $1 | wc -w) - $lettre" 
		done | sort -h #Cette fois ci l'affichage est par ordre croissant  
else
	echo "langstat: impossible d'accéder à $1: aucun fichier de ce type ou paramètres non définies"
fi


