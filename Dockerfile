FROM tobix/pywine:3.13

WORKDIR /mt5docker

# xvfb / x11vnc / novnc
RUN apt update && \
    apt install xvfb x11vnc python3-websockify python3-numpy procps -y && \
    curl -L -o noVNC.zip https://github.com/novnc/noVNC/archive/refs/heads/master.zip && \
    unzip noVNC.zip && \
    rm /mt5docker/noVNC.zip

# mt5
ARG MT5_PATH="/opt/wineprefix/drive_c/Program Files/MetaTrader 5"
COPY /mt5 ${MT5_PATH}
COPY start.sh /mt5docker
RUN curl -L -o mt5setup.exe https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe && \
    wine mt5setup.exe && \
    rm /mt5docker/mt5setup.exe && \
    wine pip install MetaTrader5 && \
    curl -L -o mt5linux.zip https://github.com/hpdeandrade/mt5linux/archive/refs/heads/master.zip && \
    wine pip install mt5linux.zip && \
    rm /mt5docker/mt5linux.zip

ENTRYPOINT ["sh", "./start.sh"]