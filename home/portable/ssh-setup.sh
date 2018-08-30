#!/bin/bash

echo -e "Checking if you have setup a key for serve ssh connection ..."
read -p $'Enter the ssh address in username@ip.address format\n> ' REPLY

ssh -o BatchMode=yes $REPLY 'exit'
if [ $? -eq 0 ]
then
  echo -e "You're done"
else
  echo -e "Set up a ssh key please "
  if [[ ! -e ~/.ssh/id_rsa.pub ]]; then
    ssh-keygen
  fi
  ssh $REPLY 'mkdir -pm 700 ~/.ssh; echo ' $(< ~/.ssh/id_rsa.pub) ' >> ~/.ssh/authorized_keys ; chmod 600 ~/.ssh/authorized_keys'
fi
