#!/usr/bin/env bash

if [ $# -eq 0 ]
    then
        echo "Wrong input arguments, expect [username] [password]"
        exit
fi

echo "Adding user and group '$1'"
useradd -m -p $(openssl passwd -1 $2) -U $1
hdddir=$(find /mnt -maxdepth 2 -name "$1")
i=0
for dir in $hdddir; do
    if [ $i -eq 0 ]
        then
            target="/home/$1/data"
        else
            target="/home/$1/data$i"
    fi
    echo "linking $dir to $target"
    ln -f -s $dir $target
    i=$((i+1))
done

if [ $i -eq 0 ]
    then
        mostFreeDisk=$(df | grep /dev/sd.*/mnt | sort -rn -k 5 | tail -1 | awk '{ print $6 }')
        echo "Making dir $1 in $mostFreeDisk"
        datadir="$mostFreeDisk/$1"
        mkdir $datadir
        chown $1:$1 $datadir
        ln -f -s $datadir /home/$1/data
        echo "linking $datadir to /home/$1/data"
fi
chown -R $1:$1 /home/$1
echo "Changing default shell to bash"
echo $2 | sudo -S -H -u $1 chsh -s /bin/bash
echo "Done"
