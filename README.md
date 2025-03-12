# mt5docker

## How To Use

1. Clone the repo and make sure Docker is installed.
2. Edit the **compose.yaml** file by setting a value to MT5_HOST and VNC_PW environment variables. Leave the ports unchanged, otherwise update the new ones in start.sh script accordingly.
3. Run ```docker compose up -d```.
4. Access your MT5 instance at http://MT5_HOST:6081/vnc.html, replacing MT5_HOST by the value assigned to it (localhost in most cases). Password to connect is the value set to VNC_PW.
5. Proceed with the installation of C++ Redistributable packages and the MT5 itself. Don't change the default installation folder.
6. Make sure you test with a DEMO account first then have fun!