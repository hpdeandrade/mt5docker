#!/bin/bash

cd /mt5docker

# remove display lock if any
rm -rf /tmp/.X100-lock

# set up display
export DISPLAY=:100
Xvfb :100 -ac -screen 0 1024x768x24 &
x11vnc -storepasswd $VNC_PW /mt5docker/passwd
x11vnc -display :100 -forever -rfbport 5901 -rfbauth /mt5docker/passwd &
chmod 600 /mt5docker/passwd
/mt5docker/noVNC-master/utils/novnc_proxy --vnc localhost:5901 --listen 6081 &

# install vc_redist_x86 if not installed yet
if [ ! -f "/mt5docker/vc_redist.x86.exe" ]; then
  curl -L -o vc_redist.x86.exe https://aka.ms/vs/17/release/vc_redist.x86.exe
  wine vc_redist.x86.exe
fi

# install vc_redist_x64 if not installed yet
if [ ! -f "/mt5docker/vc_redist.x64.exe" ]; then
  curl -L -o vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe
  wine vc_redist.x64.exe
fi

# install mt5 if not installed yet
if [ ! -f "/mt5docker/mt5setup.exe" ]; then
  curl -L -o mt5setup.exe https://download.mql5.com/cdn/web/metaquotes.ltd/mt5/mt5setup.exe
  wine mt5setup.exe
  wine taskkill /IM "terminal64.exe" /F
fi

# open mt5
mv "/mt5docker/mt5cfg.ini" "/opt/wineprefix/drive_c/Program Files/MetaTrader 5"
cd "/opt/wineprefix/drive_c/Program Files/MetaTrader 5"
wine terminal64.exe /config:mt5cfg.ini &

# open mt5 linux
cd /mt5docker
wine python -m pymt5linux --host $MT5_HOST --port 8001 C:/Python/python.exe

# prevent container termination
while true
do
  sleep 1
done