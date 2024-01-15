#!/usr/bin/env bash

IPADDR=$(ip a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $4}' | grep "121")
PORT=$(cat /etc/ssh/sshd_config | grep "Port " | awk '{print $2}')
echo "addr: ${IPADDR}, port: ${PORT}"

if [ $# -eq 0 ]
    then
        echo "Wrong input arguments, expect [username]"
        exit
fi

echo "Adding user and group '$1'"
newPasswd=$(openssl rand -base64 14)
echo "user: $1"
echo "password: $newPasswd"

useradd -m -p $(openssl passwd -1 $newPasswd) -U $1
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
echo $newPasswd | sudo -S -H -u $1 chsh -s /bin/bash
echo "Done"
