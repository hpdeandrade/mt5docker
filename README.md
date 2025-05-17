# mt5docker

## How To Use

1. Clone the repo and make sure Docker is installed.
2. Edit the compose.yaml file by setting a value to MT5_HOST and VNC_PW environment variables. Leave the ports unchanged, otherwise update the new ones in start.sh script accordingly.
3. Run `docker compose up -d`.
4. Access your MT5 instance at http://MT5_HOST:6081/vnc.html, replacing MT5_HOST by the value assigned to it (localhost in most cases). Password to connect is the value set to VNC_PW.
5. Proceed with the interactive installation of MT5. Don't change the default installation folder.
6. A connection test is performed exclusively at container startup. Check the last container logs to see if connection test was successful. To establish the connection from your script, run (see `test.py`):

```python
# import the package
from pymt5linux import MetaTrader5

# establish the connection 
# if running your script in the host machine:
mt5 = MetaTrader5(host="localhost", port=8001)

# if running your script in a separate container in the same docker network:
mt5 = MetaTrader5(host="mt5docker", port=8001)
```

7. Make sure you test with a DEMO account first, then have fun!

Most importantly, see MetaQuotes' [official documentation](https://www.mql5.com/en/docs/python_metatrader5).

## Testing Data Download

You must have a DEMO account for the following to work.

Instructions to create a DEMO account are [here](https://www.metatrader5.com/en/terminal/help/startworking/acc_open).

To test data download ([test_data_download.py](/test_download_data.py)):

```
from pymt5linux import MetaTrader5

print("Establishing connection...")
mt5 = MetaTrader5(host="localhost", port=8001)      # if running test.py in the host machine
#mt5 = MetaTrader5(host="mt5docker", port=8001)     # if running test.py in a separate container in the same docker (bridge) network

# You must create a DEMO account and login for the following to work
# See https://www.metatrader5.com/en/terminal/help/startworking/acc_open

mt5.initialize()
print(mt5.terminal_info())

google_data = mt5.copy_rates_from_pos('GOOG',mt5.TIMEFRAME_M1,0,1000)
print(google_data)

print("Closing connection...")
mt5.shutdown()
```