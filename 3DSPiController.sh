#!/bin/bash

# Check permises and go to Downloads folder if it's not root
if [[ $EUID -eq 0 ]] 
then
    echo "Don't execute this script as root"
    exit 1
else
    cd ~/Downloads || return
fi

# Read input values
read -r -p "Choose a SSID for your hotspot (Default: InputRedirection) --> " ssid
read -r -p "Choose a password for your hotspot (Default: example1234) --> " pass

# Set default values
if [ -z "$ssid" ]; then
    ssid="InputRedirection"
fi

if [ -z "$pass" ]; then
    pass="example1234"
fi


# Update, install and configurations
sudo apt-get update
sudo apt-get upgrade -y

# Xbox drivers and libraries (Change this if you want to use another controller for what you need for it)
sudo apt-get install -y libqt5gamepad5-dev qtbase5-dev
sudo apt-get install -y evtest xboxdrv

# FakeMii (Bypass 3DS internet check connection)
curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install nodejs git -y
git clone https://github.com/Lectem/fakemii

# Input Redirection client
git clone https://github.com/TuxSH/InputRedirectionClient-Qt.git
cd InputRedirectionClient-Qt || return
export QT_SELECT=5
qmake && make

# Hotspot
apt-get install dnsmasq hostapd -y
sudo systemctl stop dnsmasq
sudo systemctl stop hostapd

# Interface IP Address
sudo touch /etc/dhcpcd.conf
{
    echo 'interface wlan0'
    echo '    static ip_address=192.168.4.1/24'
    echo '    nohook wpa_supplicant'
} > /etc/dhcpcd.conf
sudo service dhcpcd restart

# DCHP Server for Hotspot
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo touch /etc/dnsmasq.conf
{
    echo 'interface wlan0'
    echo 'dhcp-range=192.168.4.2,192.168.4.10,255.255.255.0,24h'
} > /etc/dnsmasq.conf
sudo systemctl start dnsmasq

# Hotspot Configuration (Check SSID/channel and change password)
sudo touch /etc/hostapd/hostapd.conf
{
    echo 'country_code=US'
    echo 'interface=wlan0'
    echo "ssid=$ssid"
    echo 'channel=9'
    echo 'auth_algs=1'
    echo 'wpa=2'
    echo "wpa_passphrase=$pass"
    echo 'wpa_key_mgmt=WPA-PSK'
    echo 'wpa_pairwise=TKIP CCMP'
    echo 'rsn_pairwise=CCMP'
} > /etc/dhcpcd.conf
sed -i 's/^#DAEMON_CONF$/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

# Autostart script when user log in
mkdir /home/"$USER"/.config/autostart
touch /home/"$USER"/.config/autostart/controller.desktop
{
    echo '[Desktop Entry]'
    echo 'Type=Application'
    echo 'Name=Blank'
    echo "Exec=/bin/bash /home/$USER/controller.sh"
} > /home/"$USER"/.config/autostart/controller.desktop

# Script controller
touch /home/"$USER"/controller.sh
{
    echo 'sleep 5'
    echo 'sudo service dhcpcd restart'
    echo 'sudo systemctl start dnsmasq'
    echo 'sudo systemctl unmask hostapd'
    echo 'sudo systemctl enable hostapd'
    echo 'sudo systemctl start hostapd'
    echo "node /home/$USER/Downloads/fakemii/FakeMii.js &"
    echo "/home/$USER/Downloads/InputRedirectionClient-Qt/InputRedirectionClient-Qt"
} > /home/"$USER"/controller.sh

# Finish install
printf '\n\n'
echo "Now you need to setup the 3DS IP Address in Input Redirection Client"
echo "The IP Address you need to set is 192.168.4.2"
echo "If you connect other devices to this hotspot you may find problems connecting your 3DS in future"
echo "If you want use another 3DS probably you will need to change the IP Address because the DHCP server"
printf '\n\n'

count=10
while [ $count -gt 0 ]
do
    echo -e "\e[1A\e[KInput Redirection Client will be open in $count"
    sleep 1
    count=$((count - 1))
done

/home/"$USER"/Downloads/InputRedirectionClient-Qt/InputRedirectionClient-Qt

printf '\n'
echo "Reboot your Raspberry Pi to see the changes"
echo "Thanks for use 3DSPiController!"
echo "https://github.com/Layraaa/3DSPiController"
