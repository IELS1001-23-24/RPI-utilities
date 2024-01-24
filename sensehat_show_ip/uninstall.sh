#!/bin/bash
echo "Uninstalling sensehat_show_ip service"
echo "This script must be run as root"
echo ""
echo "THIS WILL REMOVE THE SERVICE FILE AND THE PYTHON SCRIPT FROM THE ROOT DIRECTORY"
echo "THE SERVICE WILL BE STOPPED AND DISABLED"
echo "to just disable the service, run 'sudo systemctl disable sensehat_show_ip.service'"
echo ""
echo "comfirm uninstallation? (y/n)"
read confirm
if [ "$confirm" != "y" ]; then
    echo "Uninstallation aborted"
    exit 1
fi
echo "checking root privileges"
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi
echo "uninstalling service"
sudo systemctl stop sensehat_show_ip.service # stop the service
sudo systemctl disable sensehat_show_ip.service # disable the service
echo "removing files"
sudo rm /etc/systemd/system/sensehat_show_ip.service # remove the service file from the systemd service directory
sudo rm /showip.py # remove the python script from the root directory
sudo systemctl daemon-reload # reload the systemd daemon
echo "Uninstallation complete"
echo "To check the status of the service, run 'sudo systemctl status sensehat_show_ip.service'"
echo ""
echo "To reinstall, run install.sh"