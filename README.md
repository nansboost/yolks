# custom nodejs yolks (terminal egg)

Builds 4 Docker images with **Node.js + Chromium (puppeteer-ready) + pm2** and
pushes them to your own GitHub Container Registry namespace:

```
ghcr.io/nansboost/yolks:nodejs_22
ghcr.io/nansboost/yolks:nodejs_23
ghcr.io/nansboost/yolks:nodejs_24
ghcr.io/nansboost/yolks:nodejs_25
```

## How to use

1. Create a new GitHub repo named `yolks` under **nansboost** (private is
   fine) and push **the contents of this folder** as the repo root:
   (repo name `yolks` = package name → package auto-links to the repo)
   ```bash
   cd yolks-custom
   git init && git add -A && git commit -m "custom nodejs yolks"
   git remote add origin https://github.com/nansboost/yolks.git
   git push -u origin main
   ```
2. The Actions workflow runs automatically (4 parallel builds, one per node
   version). `GITHUB_TOKEN` handles the ghcr.io login - no PAT needed.
3. **Make the package public** (first publish is private, wings cannot pull
   private images):
   GitHub → your profile → Packages → `yolks` → Package settings →
   Danger Zone → Change visibility → **Public**.
4. Point the egg at the new images:
   ```json
   "docker_images": {
     "Node.js 22 + Chromium + PM2": "ghcr.io/nansboost/yolks:nodejs_22",
     "Node.js 23 + Chromium + PM2": "ghcr.io/nansboost/yolks:nodejs_23",
     "Node.js 24 + Chromium + PM2": "ghcr.io/nansboost/yolks:nodejs_24",
     "Node.js 25 + Chromium + PM2": "ghcr.io/nansboost/yolks:nodejs_25"
   }
   ```

## Inside the image

- Debian bookworm-slim + official NodeSource node (22/23/24/25)
- `chromium` (system package, real browser, not the snap stub) + fonts
- global: `pm2`, `yarn`
- build tools (make/gcc/g++/python3) so `npm install` can compile native modules
- `PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium` + `PUPPETEER_SKIP_DOWNLOAD=true`
  → `npm i puppeteer` works instantly, no chrome download at install time
- `container` user (uid 988), `/home/container` workdir - wings compatible

## Notes

- Puppeteer must launch with `--no-sandbox` in containers (running as non-root
  without user namespaces).
- To add more global tools (tsx, typescript, nodemon...), extend the
  `npm install -g pm2 yarn` line in `dockerfiles/nodejs.Dockerfile` and push -
  Actions rebuilds automatically.
- The egg's install container can also use the image
  (`scripts.installation.container = ghcr.io/nansboost/yolks:nodejs_22`).
