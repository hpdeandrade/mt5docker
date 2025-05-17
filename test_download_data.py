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
