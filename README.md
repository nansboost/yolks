# custom nodejs yolks (terminal egg)

Struktur mengikuti pola resmi [pelican-eggs/yolks](https://github.com/pelican-eggs/yolks),
dengan tambahan **Chromium (puppeteer-ready) + pm2**:

```
ghcr.io/nansboost/yolks:nodejs_22
ghcr.io/nansboost/yolks:nodejs_23
ghcr.io/nansboost/yolks:nodejs_24
ghcr.io/nansboost/yolks:nodejs_25
```

## Struktur (mirip resmi)

```
.github/workflows/nodejs.yml   # matrix build 22-25, amd64+arm64, push ke GHCR
nodejs/
├── entrypoint.sh              # eval $STARTUP dari wings (pola resmi yolks)
├── 22/Dockerfile              # FROM node:22-trixie-slim + ...
├── 23/Dockerfile
├── 24/Dockerfile
└── 25/Dockerfile
```

## Isi image

- Debian trixie-slim + Node resmi (22/23/24/25), multi-arch amd64+arm64
- Toolkit resmi yolks: ffmpeg, sqlite3, git, python3, build-essential, tini, dll.
- Tambahan: **chromium** + fonts (puppeteer siap pakai, tanpa download chrome),
  global **pm2**, typescript/ts-node/tsx, pnpm via corepack (yarn sudah bawaan)
- `STOPSIGNAL SIGINT` + `tini` PID-1 + `entrypoint.sh` (eval `$STARTUP`) - persis
  pola resmi, jadi kompatibel penuh dengan Wings
- user `container`, `WORKDIR /home/container`

## Publish

Push repo ini ke `github.com/nansboost/yolks` (branch `main`) → Actions jalan
otomatis → setelah hijau, set package **Public**
(profil → Packages → yolks → Package settings → Change visibility → Public).

## Catatan egg

- Puppeteer harus launch dengan `--no-sandbox` di container.
- Install container egg bisa ikut pakai image ini
  (`scripts.installation.container = ghcr.io/nansboost/yolks:nodejs_22`).
