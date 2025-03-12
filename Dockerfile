FROM hpdeandrade/pywinedev:3.13

WORKDIR /mt5docker

RUN apt update && \
    apt install xvfb x11vnc python3-websockify python3-numpy procps -y && \
    curl -L -o noVNC.zip https://github.com/novnc/noVNC/archive/refs/heads/master.zip && unzip noVNC.zip && rm noVNC.zip && \
    wine pip install MetaTrader5 pymt5linux

COPY start.sh mt5cfg.ini /mt5docker/

ENTRYPOINT ["./start.sh"]