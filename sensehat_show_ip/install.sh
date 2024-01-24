#!bin/bash
echo "Installing sensehat_show_ip service"
echo "This script must be run as root"
echo "comfirm installation? (y/n)"
read confirm
if [ "$confirm" != "y" ]; then
    echo "Installation aborted"
    exit 1
fi
echo "checking root privileges"
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi
echo "copying files"
cp ./RPI-utilities/sensehat_show_ip/showip.py /showip.py # copy the python script to the root directory
cp ./RPI-utilities/sensehat_show_ip/showip.service /etc/systemd/system/sensehat_show_ip.service # copy the service file to the systemd service directory
echo "enabling service"
sudo systemctl daemon-reload # reload the systemd daemon
sudo systemctl enable sensehat_show_ip.service # enable the service
sudo systemctl start sensehat_show_ip.service # start the service
sudo systemctl status sensehat_show_ip.service # check the status of the service
echo "Installation complete"
echo "IP address should be displayed on the sensehat LED matrix upon boot"
echo ""
echo "To check the status of the service, run 'sudo systemctl status sensehat_show_ip.service'"
echo "To disable the service, run 'sudo systemctl disable sensehat_show_ip.service'"
echo ""
echo "To uninstall, run uninstall.sh"
