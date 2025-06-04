#!/usr/bin/env python3

from pymt5linux import MetaTrader5

print("Establishing connection...")
mt5 = MetaTrader5(host="localhost", port=8001)      # if running test.py in the host machine
#mt5 = MetaTrader5(host="mt5docker", port=8001)     # if running test.py in a separate container in the same docker (bridge) network

print("Closing connection...")
mt5.shutdown()