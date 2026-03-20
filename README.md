# mt5docker
Welcome to mt5docker repository!

Before stepping into the below, take a look at MetaQuotes' [official Python MQL5 documentation](https://www.mql5.com/en/docs/python_metatrader5).

This image is based on [webcomics' pywine image](https://github.com/webcomics/pywine) upon wine-staging.

## How To Use
1\. Clone the repo and make sure Docker is installed (docker-compose is optional).

2\. Run the image from docker directly or initiate it from compose. Remember to set a value for VNC_PWD (edit the compose.yaml file if running from compose). Keep MT5_HOST value as mt5docker.

Run directly: `docker run -e MT5_HOST=mt5docker -e VNC_PWD=<YOUR_VNC_PASSWORD> -p 5901:5901 -p 6081:6081 -p 8001:8001 --name mt5docker hpdeandrade/mt5docker:latest`

Run from compose (docker-compose must be installed): `docker compose up -d`

3\. Access your MT5 instance at http://mt5docker:6081/vnc.html.

4\. Proceed with the interactive installation of MT5. Don't change the default installation folder.

5\. In your script ([pymt5linux](https://github.com/hpdeandrade/pymt5linux) required), run:

```python
# estblish connection to MT5
from pymt5linux import MetaTrader5
mt5 = MetaTrader5(host="mt5docker", port=8001)
``` 

...or if on localhost:

```python
# estblish connection to MT5
from pymt5linux import MetaTrader5
mt5 = MetaTrader5(host="localhost", port=8001)
``` 

6\. Make sure you test with a [DEMO account](https://www.metatrader5.com/en/mobile-trading/android/help/settings_accounts/account_open) first, then have fun!

## Notes
**Startup check:** A connection test is performed exclusively at startup. If you run into any issues, check the last container logs to see if connection test was successful.

**Optionally running on localhost:** This whole setup is designed to run on an isolated network, but you can also run on localhost (not recommended though). Repeat the steps above adding `--network host` if running from docker directly or uncomment the `network_mode: host` line in the compose.yaml file if running from compose. Finally, replace all host references from mt5docker to localhost.