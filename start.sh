# open mt5 terminal
export DISPLAY=:100
Xvfb :100 -ac -screen 0 1280x960x24 &
cd "/opt/wineprefix/drive_c/Program Files/MetaTrader 5"
wine terminal64.exe /config:custom.ini &

# set up x11vnc
cd /mt5docker
x11vnc -storepasswd $VNC_PASSWORD /mt5docker/passwd
x11vnc -display :100 -forever -rfbport 5901 -rfbauth /mt5docker/passwd &
chmod 600 /mt5docker/passwd

# set up novnc
cd /mt5docker/noVNC-master
./utils/novnc_proxy --vnc localhost:5901 --listen 6081 &

# set up mt5linux server
cd /mt5docker
wine python -m mt5linux --host $MT5_HOST --port 8001 C:/Python/python.exe

# prevent container termination
while true
do
  sleep 1
done