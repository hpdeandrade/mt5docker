FROM hpdeandrade/pywinedev:3.13

WORKDIR /mt5docker

RUN apt update && \
    apt install cabextract xvfb x11vnc python3-websockify python3-numpy procps -y && \
    curl -L -o noVNC.zip https://github.com/novnc/noVNC/archive/refs/heads/master.zip && unzip noVNC.zip && rm noVNC.zip && \
    wine pip install MetaTrader5 pymt5linux && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L -o winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    mv winetricks /usr/bin/ && \
    xvfb-run sh -c "winetricks --unattended vcrun2019" && \
    rm -rf /tmp/*

COPY start.sh mt5cfg.ini test.py /mt5docker/

ENTRYPOINT ["./start.sh"]