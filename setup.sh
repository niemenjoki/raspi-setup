#!/bin/bash

CYAN='\033[0;36m'
RED='\033[0;31m'
NOCOLOR='\033[0m'

echo -e "${CYAN}RASPBERRY PI SETUP"
echo "---------------------------"

echo "Give the Raspberry Pi a unique hostname:"
read hostname
sed -i "s/raspberrypi/$hostname/" /etc/hostname
sed -i "s/raspberrypi/$hostname/" /etc/hosts
echo "[STATUS] Hostname updated"
echo -e "${RED}REMEMBER TO ADD A HOSTNAME STICKER TO THE CASE OF THE PI"
sleep 2

echo -e "${CYAN}[STATUS] Looking for updates..${NOCOLOR}"
sudo apt-get update -y
echo -e "${CYAN}[STATUS] Starting to update..${NOCOLOR}"
sudo apt dist-upgrade -y
echo -e "${CYAN}[STATUS] Update finished"

echo "[STATUS] Setting up automatic updates.."
sudo cp ./auto-update.sh /usr/bin/auto-update.sh
sudo chmod +x /usr/bin/auto-update.sh
sudo cp ./weekly-reboot.sh /usr/bin/weekly-reboot.sh
sudo chmod +x /usr/bin/weekly-reboot.sh
sudo crontab -l > newCron
echo "@reboot sudo bash /usr/bin/auto-update.sh &" >> newCron
echo "0 3 * * * sudo bash /usr/bin/weekly-reboot.sh &" >> newCron
sudo crontab newCron
sudo rm newCron
echo "[STATUS] Automatic updates setup"

echo "[STATUS] Installing an xrdp-server for Remote Desktop access..${NOCOLOR}"
sudo apt-get install xrdp -y
echo -e "${CYAN}[STATUS] xrdp server installed"

cd /home/pi
echo "[STATUS] Raspberry Pi setup ready"