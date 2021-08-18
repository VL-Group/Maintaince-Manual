#!/usr/bin/env bash

# find . -maxdepth 1 -type d | sudo bash ~/set.sh
while read line;
do
	if [[ "$line" == *"+"* ]]
	then
		continue	
	fi
	if [[ "$line" == *" "* ]]
	then 
		continue
	fi
	if [[ "$line" == "." ]]
	then
		continue
	fi
	user=${line:2}
    chown -R $user:$user $user
	echo "Change owner of $user completed"	
done
