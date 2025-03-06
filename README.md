# mt5docker

## How To Use

1. Clone the repo and make sure Docker is installed.
2. Edit the **compose.yaml** file by setting a value to VNC_PASSWORD and MT5_HOST env variables. Leave the ports unchanged, otherwise update the new ones in start.sh script accordingly.
3. Run ```docker compose up -d```.
4. Access your MT5 instance at http://MT5_HOST:6081/vnc.html, replacing MT5_HOST by the value assigned to this variable. Password to connect is the value set to VNC_PASSWORD.
5. Have fun!