import os
from pymt5linux import MetaTrader5

print("Establishing connection...")
MT5_HOST = os.getenv("MT5_HOST")
mt5 = MetaTrader5(host=MT5_HOST, port=8001)

print("Closing connection...")
mt5.shutdown()