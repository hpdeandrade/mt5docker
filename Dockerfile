# below image is based on tobix/pywine image - https://hub.docker.com/r/tobix/pywine
# only difference is that we re-build the image with wine-staging to support MT5
FROM hpdeandrade/pywine-staging:3.14

WORKDIR /mt5docker

RUN apt-get update && \
    apt-get install -y --no-install-recommends cabextract xvfb x11vnc python3-websockify python3-numpy procps fluxbox wmctrl && \
    apt-get clean && \
    curl -fL -o noVNC.zip https://github.com/novnc/noVNC/archive/refs/heads/master.zip && unzip noVNC.zip && rm noVNC.zip && \
    rm -rf /var/lib/apt/lists/*

# renovate: datasource=github-releases depName=Winetricks/winetricks
ARG WINETRICKS_VERSION=20260125

# Only installs the winetricks script itself (needs root to write to
# /usr/bin). Actually running it against the Wine prefix happens later, as
# mt5user - see the USER switch below for why.
RUN curl -fL -o winetricks "https://raw.githubusercontent.com/Winetricks/winetricks/${WINETRICKS_VERSION}/src/winetricks" && \
    chmod +x winetricks && \
    mv winetricks /usr/bin/

# Drop to a non-root user before anything touches the Wine prefix. Wine
# refuses to run at all if $WINEPREFIX isn't owned by the current user, and
# building as root then running as a different user at container startup
# breaks it outright (hit this: MT5 install failed once run and build used
# different users). So mt5user takes ownership here, once, and every
# following RUN/ENTRYPOINT step - at build time and at container runtime -
# uses that same user from this point on.
RUN useradd --create-home --uid 1000 mt5user && \
    chown -R mt5user:mt5user /mt5docker /opt/wineprefix
USER mt5user

COPY --chown=mt5user:mt5user pyproject.toml uv.lock ./

# renovate: datasource=github-releases depName=astral-sh/uv versioning=semver
ARG UV_VERSION=0.11.29

# Install uv into the Wine prefix's Python dir (already on the Windows PATH via
# PrependPath=1 in pywine-staging), then build the Windows-side venv containing
# the Windows-only Python deps (MetaTrader5, pymt5linux) at image build time.
RUN curl -fL -o uv.zip "https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-x86_64-pc-windows-msvc.zip" && \
    unzip uv.zip uv.exe -d /opt/wineprefix/drive_c/Python && \
    rm uv.zip && \
    wine uv sync --frozen --no-cache

# vcrun2019 has no display-dependent UI, but winetricks still expects a DISPLAY
# to exist, hence xvfb-run just for this step (Xvfb itself only runs at
# container start, in start.sh).
RUN xvfb-run -a winetricks --unattended vcrun2019

COPY --chown=mt5user:mt5user start.sh mt5cfg.ini tests ./
RUN chmod +x ./start.sh

ENTRYPOINT ["./start.sh"]
