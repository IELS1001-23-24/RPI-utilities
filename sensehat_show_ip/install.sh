#!bin/bash
cp ~/RPI-utilities/sensehat_show_ip/showip.py /showip.py # copy the python script to the root directory
cp ~/RPI-utilities/sensehat_show_ip/showip.service /etc/systemd/system/sensehat_show_ip.service # copy the service file to the systemd service directory
sudo systemctl daemon-reload # reload the systemd daemon
sudo systemctl enable sensehat_show_ip.service # enable the service
sudo systemctl start sensehat_show_ip.service # start the service
sudo systemctl status sensehat_show_ip.service # check the status of the service
