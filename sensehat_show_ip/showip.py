# Script to show the IP address of the Raspberry Pi on the SenseHat LED matrix
# Used to find the IP address of the Raspberry Pi when it is connected to a new network
#
# Press the middle button on the SenseHat joystick to exit the script
#
# Written for NTNU IELS2001 spring 2024
# Author: Trond F. Christensen

from time import sleep
from sense_hat import SenseHat
import socket

sense = SenseHat()

def get_ip_address():
    ip_address = ''
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8",80))
    ip_address = s.getsockname()[0]
    s.close()
    return ip_address

while True:
    sense.show_message("IP:"+get_ip_address())
    sleep(2)
    for event in sense.stick.get_events():
        if event.direction == "middle":
            exit()