#/bin/bash

################################################################################
# Author:   MadStuntman
# Date:     March, 20th 2018
# Discord:  MadStuntman#0467
# 
# Program:
#
#   Install AeriumX Beta masternode on clean VPS with Ubuntu 16.04 
#
# 
################################################################################

echo && echo 
echo "****************************************************************************"
echo "*                                                                          *"
echo "*  This script will install and configure your AeriumX Beta masternode.    *"
echo "*                                                                          *"
echo "****************************************************************************"
echo && echo

echo "Do you want to start the installation? [y/n]"
read DOSETUP
if [[ $DOSETUP =~ "y" ]] ; then

# Install necessary stuff

cd ~
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get install -y nano htop git
sudo apt-get install -y software-properties-common
sudo apt-get install -y build-essential libtool autotools-dev pkg-config libssl-dev
sudo apt-get install -y libboost-all-dev
sudo apt-get install -y libevent-dev
sudo apt-get install -y libzmq3-dev
sudo apt-get install -y libminiupnpc-dev
sudo apt-get install -y autoconf
sudo apt-get install -y automake unzip
sudo add-apt-repository  -y  ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

cd /var
sudo touch swap.img
sudo chmod 600 swap.img
sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
sudo mkswap /var/swap.img
sudo swapon /var/swap.img
sudo free
sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
cd

sudo apt-get install -y ufw
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow 60484/tcp
sudo ufw logging on
sudo ufw enable
sudo ufw status

mkdir -p ~/bin
echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
source ~/.bashrc
wget https://github.com/aeriumcoin/AeriumX-BETA/releases/download/v1.1/Linux.-.Ubuntu.16.04.zip
sudo unzip Linux.-.Ubuntu.16.04.zip
sudo chmod -R 777 "Linux - Ubuntu 16.04"
sudo mv "Linux - Ubuntu 16.04"/* /usr/bin
sudo rm -rf "Linux - Ubuntu 16.04"
sudo rm Linux.-.Ubuntu.16.04.zip

echo && echo && echo
echo "Wake up! We are almost done!"
echo ""
echo "Type the IP of this server, followed by [ENTER]:"
read IP

echo ""
echo "Enter masternode private key for node $ALIAS"
read PRIVKEY

CONF_DIR=~/.Altair/
CONF_FILE=Altair.conf

mkdir -p $CONF_DIR
echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=256" >> $CONF_DIR/$CONF_FILE
echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "" >> $CONF_DIR/$CONF_FILE
echo "port=60484" >> $CONF_DIR/$CONF_FILE
echo "masternodeaddress=$IP:60484" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE

Altaird -daemon

echo && echo 
echo "Your AeriumX Masternode is now ready! Start it with the controller wallet!"
else
echo && echo 
echo "Exit. Nothing has been done!"
fi
