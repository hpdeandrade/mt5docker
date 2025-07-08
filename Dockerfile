FROM hpdeandrade/pywine:staging

WORKDIR /mt5docker

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends cabextract xvfb x11vnc python3-websockify python3-numpy procps && \
    apt-get clean && \
    curl -L -o noVNC.zip https://github.com/novnc/noVNC/archive/refs/heads/master.zip && unzip noVNC.zip && rm noVNC.zip && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN wine pip install -r requirements.txt

RUN curl -L -o winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    mv winetricks /usr/bin/ && \
    xvfb-run sh -c "winetricks --unattended vcrun2019"

COPY start.sh mt5cfg.ini tests ./

ENTRYPOINT ["./start.sh"]