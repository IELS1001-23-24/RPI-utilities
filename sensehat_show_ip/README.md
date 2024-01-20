# Vis IP-adresse på SenseHat
Denne guiden viser hvordan du kan vise IP-adressen til Raspberry Pi på SenseHat LED-matrisen. Dette kan være nyttig når du skal koble deg til et nettverk hvor du ikke vet IP-adressen til Raspberry Pi.

Koden er skrevet slik at Raspberry Pi vil finne sin egen IP-adresse og vise den på LED-matrisen. Denne vill vises gang på gang helt til du trykker på midtknappen på SenseHat joysticken.  

Koden er skrevet for Python 3 og SenseHat biblioteket. Den er testet på en Raspberry Pi 3B+ med SenseHat.
## Installering
Føst må SenseHat biblioteket installeres.
Dette gjøres ved å skrive følgende i terminalen:
```bash
sudo apt-get update
sudo apt-get install sense-hat
```
Deretter må det lages et Python script som viser IP-adressen på LED-matrisen.
Dette gjøres ved å skrive følgende i terminalen:
```
sudo nano /showip.py
```
Lim inn følgende kode i teksteditoren og lagre filen (Ctrl+X, Y, Enter).

```python
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
```
Test at scriptet fungerer ved å skrive følgende i terminalen:
```bash
python3 showip.py
```
## Autostart
For å få scriptet til å starte automatisk ved oppstart av Raspberry Pi må det lages en systemd service.
Dette gjøres ved å skrive følgende i terminalen:
```
sudo nano /etc/systemd/system/showip.service
```
Lim inn følgende tekst i teksteditoren og lagre filen (Ctrl+X, Y, Enter).
```service
[Unit]
Description=Python script that shows IP address on SenseHat
After=multi-user.target

[Service]
User=root
WorkingDirectory=/
Restart=on-failure
RestartSec=5s
ExecStart=/usr/bin/python3 showip.py
SyslogIdentifier=showip

[Install]
WantedBy=multi-user.target
```
Start systemd servicen og la den starte automatisk ved oppstart av Raspberry Pi ved å skrive følgende i terminalen:
```
sudo systemctl daemon-reload
sudo systemctl enable showip.service
sudo systemctl start showip.service
```
Etter dette vil IP-adressen til Raspberry Pi vises på LED-matrisen hver gang den starter opp.