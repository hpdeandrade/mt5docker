from pymt5linux import MetaTrader5

print("Establishing connection...")
mt5 = MetaTrader5(host="mt5docker", port=8001)

print("Closing connection...")
mt5.shutdown()