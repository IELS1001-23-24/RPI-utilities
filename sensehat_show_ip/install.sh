#!bin/bash
cp sensehat_show_ip.py /sensehat_show_ip.py # copy the python script to the root directory
cp sensehat_show_ip.service /etc/systemd/system/sensehat_show_ip.service # copy the service file to the systemd service directory
sudo systemctl daemon-reload # reload the systemd daemon
sudo systemctl enable sensehat_show_ip.service # enable the service
sudo systemctl start sensehat_show_ip.service # start the service
sudo systemctl status sensehat_show_ip.service # check the status of the service
