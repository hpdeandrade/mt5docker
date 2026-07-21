# Below is tobix' image (https://hub.docker.com/r/tobix/pywine) built upon wine-staging instead of wine-stable for better compatibility with MT5
FROM hpdeandrade/pywine-staging:3.14

WORKDIR /mt5docker

RUN apt-get update && \
    apt-get install -y --no-install-recommends cabextract xvfb x11vnc python3-websockify python3-numpy procps fluxbox wmctrl && \
    apt-get clean && \
    curl -fL -o noVNC.zip https://github.com/novnc/noVNC/archive/refs/heads/master.zip && unzip noVNC.zip && rm noVNC.zip && \
    rm -rf /var/lib/apt/lists/*

# renovate: datasource=github-releases depName=Winetricks/winetricks
ARG WINETRICKS_VERSION=20260125

# Install winetricks
RUN curl -fL -o winetricks "https://raw.githubusercontent.com/Winetricks/winetricks/${WINETRICKS_VERSION}/src/winetricks" && \
    chmod +x winetricks && \
    mv winetricks /usr/bin/

# Drop to a non-root user before anything touches the Wine prefix
RUN useradd --create-home --uid 1000 mt5user && \
    chown -R mt5user:mt5user /mt5docker /opt/wineprefix
USER mt5user

COPY --chown=mt5user:mt5user pyproject.toml uv.lock ./

# renovate: datasource=github-releases depName=astral-sh/uv versioning=semver
ARG UV_VERSION=0.11.29

# Install uv into the Wine prefix
RUN curl -fL -o uv.zip "https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-x86_64-pc-windows-msvc.zip" && \
    unzip uv.zip uv.exe -d /opt/wineprefix/drive_c/Python && \
    rm uv.zip && \
    wine uv sync --frozen --no-cache

# Install vcrun2019
RUN xvfb-run -a winetricks --unattended vcrun2019

COPY --chown=mt5user:mt5user start.sh mt5cfg.ini tests ./
RUN chmod +x ./start.sh

ENTRYPOINT ["./start.sh"]
