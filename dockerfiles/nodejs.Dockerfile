# syntax=docker/dockerfile:1
# Custom Pterodactyl/Pelican yolk: Node.js + Chromium (puppeteer-ready) + pm2
# Build-arg NODE_VERSION selects the node line (22/23/24/25).
ARG NODE_VERSION=22
FROM node:${NODE_VERSION}-bookworm-slim

# tools for the terminal egg + native module builds + chromium + fonts
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git curl wget jq file unzip ca-certificates \
        make gcc g++ python3 \
        chromium \
        fonts-liberation fonts-noto-color-emoji \
    && npm install -g pm2 yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# puppeteer: use the system chromium instead of downloading chrome-for-testing
ENV PUPPETEER_SKIP_DOWNLOAD=true \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Wings expects the container to run as this user (uid 988)
RUN useradd -m -d /home/container -u 988 container
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container
