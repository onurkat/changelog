#!/bin/bash

# Author : Onur Kat
# Contact info : github.com/onurkat

echo "This script will install Changelog Generator script from github.com/onurkat/changelog" 
echo "Do you want to continue? [Y/n]"

TEMP_DIR="/tmp/changelog"

while : 
do
read selection
  case $selection in
	y | Y)	break
		;;
	n | N)	return			
		;;
	*)
		echo "[Select y or n only]"		
		;;
  esac
done

if [ -d "$TEMP_DIR" ];then
sudo rm -rf $TEMP_DIR
fi

sudo git clone https://github.com/onurkat/changelog.git $TEMP_DIR

CHECK_IF_INSTALLED=$(cat ~/.bashrc | grep "source /usr/local/bin/changelog.sh")
if [ "" = "$CHECK_IF_INSTALLED" ]; then
echo 'alias changelog='\''source /usr/local/bin/changelog.sh'\' >> ~/.bashrc
echo ''>> ~/.bashrc
else
echo ".basrc file's been already configured. Skipping..."
fi

cd $TEMP_DIR
sudo chmod +x *.sh
sudo mv *.sh /usr/local/bin
cd ~/
sudo rm -rf $TEMP_DIR
source ~/.bashrc
cd ~/

echo "Installation has been completed. Now you can use 'changelog' command for your projects."

