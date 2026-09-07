FROM        --platform=$TARGETOS/$TARGETARCH node:23-bookworm-slim

LABEL       author="nansboost"
LABEL       org.opencontainers.image.source="https://github.com/nansboost/yolks"

# add container user and set stop signal (egg stop command is ^C / SIGINT)
RUN         useradd -m -d /home/container container
STOPSIGNAL  SIGINT

RUN         apt update \
            && apt -y install \
                ffmpeg \
                iproute2 \
                git \
                sqlite3 \
                libsqlite3-dev \
                python3 \
                python3-dev \
                ca-certificates \
                dnsutils \
                tzdata \
                zip \
                tar \
                curl \
                build-essential \
                libtool \
                iputils-ping \
                libnss3 \
                tini \
                chromium \
                fonts-liberation \
                fonts-noto-color-emoji \
                imagemagick \
                webp \
                golang-go

# global npm tooling (npm pinned: npm 12 rejects node 23 engines;
# yarn ships with node via corepack - do NOT npm i -g yarn)
RUN         npm install --global npm@11.18.0 typescript ts-node @types/node tsx pm2 bun
RUN         npm install -g corepack \
            && corepack enable \
            && corepack prepare pnpm@latest --activate

# puppeteer: use the system chromium, skip chrome-for-testing download
ENV         PUPPETEER_SKIP_DOWNLOAD=true \
            PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
            PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        --chown=container:container ./../entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
