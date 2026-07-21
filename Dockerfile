# below image is based on tobix/pywine image - https://hub.docker.com/r/tobix/pywine
# change image tag to latest to follow webcomics updates - https://github.com/webcomics/pywine
FROM hpdeandrade/pywine-staging:3.14

WORKDIR /mt5docker

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends cabextract xvfb x11vnc python3-websockify python3-numpy procps && \
    apt-get clean && \
    curl -fL -o noVNC.zip https://github.com/novnc/noVNC/archive/refs/heads/master.zip && unzip noVNC.zip && rm noVNC.zip && \
    rm -rf /var/lib/apt/lists/*

COPY pyproject.toml uv.lock ./

# renovate: datasource=github-releases depName=astral-sh/uv versioning=semver
ARG UV_VERSION=0.11.29

# Install uv into the Wine prefix's Python dir (already on the Windows PATH via
# PrependPath=1 in pywine-staging), then build the Windows-side venv containing
# the Windows-only Python deps (MetaTrader5, pymt5linux) at image build time.
RUN curl -fL -o uv.zip "https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-x86_64-pc-windows-msvc.zip" && \
    unzip uv.zip uv.exe -d /opt/wineprefix/drive_c/Python && \
    rm uv.zip && \
    wine uv sync --frozen --no-cache

# renovate: datasource=github-releases depName=Winetricks/winetricks
ARG WINETRICKS_VERSION=20260125

# vcrun2019 has no display-dependent UI, but winetricks still expects a DISPLAY
# to exist, hence xvfb-run just for this step (Xvfb itself only runs at
# container start, in start.sh).
RUN curl -fL -o winetricks "https://raw.githubusercontent.com/Winetricks/winetricks/${WINETRICKS_VERSION}/src/winetricks" && \
    chmod +x winetricks && \
    mv winetricks /usr/bin/ && \
    xvfb-run -a winetricks --unattended vcrun2019

COPY start.sh mt5cfg.ini tests ./
RUN chmod +x ./start.sh

ENTRYPOINT ["./start.sh"]