# mt5docker

## How To Use

1. Clone the repo and make sure Docker is installed.
2. Edit the **compose.yaml** file by setting a value to MT5_HOST and VNC_PW environment variables. Leave the ports unchanged, otherwise update the new ones in start.sh script accordingly.
3. Run ```docker compose up -d```.
4. Access your MT5 instance at http://MT5_HOST:6081/vnc.html, replacing MT5_HOST by the value assigned to it (localhost in most cases). Password to connect is the value set to VNC_PW.
5. Proceed with the interactive installation of MT5. Don't change the default installation folder.
6. A connection test is performed exclusively at container startup. Check the last container logs to see if connection test was successful. To establish the connection from your script, run:

`mt5 = MetaTrader5(host="localhost", port=8001)` if running your script in the host machine,

or 

`mt5 = MetaTrader5(host="mt5docker", port=8001)` if running your script in a separate container in the same docker (bridge) network.

7. Make sure you test with a DEMO account first, then have fun!

Most importantly, see MetaQuotes' [official documentation](https://www.mql5.com/en/docs/python_metatrader5).