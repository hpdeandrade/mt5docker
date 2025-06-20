# mt5docker
Welcome to mt5docker repository!

Before stepping into the below, I strongly recommend you to check MetaQuotes' [official Python MQL5 documentation](https://www.mql5.com/en/docs/python_metatrader5).

## How To Use
1\. Clone the repo and make sure Docker is installed.

2\. Edit the compose.yaml file by setting a value to MT5_HOST and VNC_PWD environment variables. It is recommended to leave the ports unchanged, but if you decide to change it, make sure to update them accordingly in the start.sh script.

3\. Run `docker compose up -d`.

4\. Access your MT5 instance at http://MT5_HOST:6081/vnc.html, replacing MT5_HOST by the value assigned to it (localhost in most cases). Password to connect is the value set to VNC_PWD.

5\. Proceed with the interactive installation of MT5. Don't change the default installation folder.

6\. A connection test is performed exclusively at container startup. Check the last container logs to see if connection test was successful. To establish the connection from your script (check tests/test_connection.py), run:

```python
# estblish connection to MT5
from pymt5linux import MetaTrader5
mt5 = MetaTrader5(host="mt5docker", port=8001)
``` 

7\. Make sure you test with a DEMO account first, then have fun!