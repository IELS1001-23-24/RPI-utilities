# Vis IP-adresse på SenseHat

- [Vis IP-adresse på SenseHat](#vis-ip-adresse-på-sensehat)
  - [Installering av SenseHat biblioteket](#installering-av-sensehat-biblioteket)
  - [Installasjon med git clone](#installasjon-med-git-clone)
  - [Manuell installering av showip.py service](#manuell-installering-av-showippy-service)
    - [Autostart](#autostart)
  
Denne guiden viser hvordan du kan vise IP-adressen til Raspberry Pi på SenseHat LED-matrisen. Dette kan være nyttig når du skal koble deg til et nettverk hvor du ikke vet IP-adressen til Raspberry Pi.

Koden er skrevet slik at Raspberry Pi vil finne sin egen IP-adresse og vise den på LED-matrisen. Denne vil vises gang på gang helt til du trykker på midtknappen på SenseHat joysticken.  

Koden er skrevet for Python 3 og SenseHat biblioteket. Den er testet på en Raspberry Pi 3B+ med SenseHat.

## Installering av SenseHat biblioteket
Føst må SenseHat biblioteket installeres.
Dette gjøres ved å skrive følgende i terminalen:
```bash
sudo apt-get update
sudo apt-get install sense-hat
```

## Installasjon med git clone
Koden kan lastes ned fra github, og installeres med install-filen som ligger der. Om dette ikke er ønskelig se [Manuell installering av showip.py service](#manuell-installering-av-showippy-service).

For å laste ned koden fra github må git være installert. Dette skal komme ferdig installert på nyere versjoner av Raspbian. For å sjekke om det er installert skriv følgende i terminalen:
```bash
git --version
```
Med git installert kan koden lastes ned ved å skrive følgende i terminalen:
```bash
cd ~ #go to home directory
git clone https://github.com/IELS1001-23-24/RPI-utilities 
```
Dette vil laste ned RPI-utilities mappen fra github til mappen du er i når du skriver kommandoen.

Etter at koden er lastet ned må install-filen kjøres. Dette gjøres ved å skrive følgende i terminalen:
```bash
cd ~
sudo bash ./RPI-utilities/sensehat_show_ip/install.sh
```

Etter dette skal IP-adressen til Raspberry Pi vises på LED-matrisen hver gang den starter opp. 
Instalasjonen kan testes ved å starte Raspberry Pi på nytt. Dette gjøres ved å skrive følgende i terminalen:
```bash
sudo reboot
```
Etter at Raspberry Pi har startet opp skal IP-adressen vises på LED-matrisen. Denne vil vises gang på gang helt til du trykker på midtknappen på SenseHat joysticken.

**Fungerer dette er installasjonen ferdig.**

Om ønskelig kan servicen avinstalleres, og koden slettes ved å skrive følgende i terminalen:
```bash
cd ~
sudo bash ./RPI-utilities/sensehat_show_ip/uninstall.sh
```

## Manuell installering av showip.py service
Om du ikke ønsker å bruke git clone kan showip.py installeres manuelt. Har du allerede installert showip.py med git clone og install.sh skal programmet fungere og du trenger ikke å gjøre dette.

Det er også mulig å installere showip.py manuelt uten å bruke git clone. For å gjøre dette må python scriptet showip.py lages og systemd servicen  settes opp manuelt.

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
### Autostart
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