# RSSHub RSS Feed Generator (Redis cache, Chromium): composer spec

Listing name: **RSSHub RSS Feed Generator (Redis cache, Chromium)** (no version label: RSSHub has only dated rolling builds)
Description (71 chars): RSS feeds for sites that have none, with an access key and Redis cache.
Category: Other. Icon: `https://cdn.jsdelivr.net/gh/selfhst/icons/svg/rsshub.svg`
Repository: `baranberkay96/rsshub-railway` (this folder is the repo root).

## Services

| Service | Source | Public | Volume | Healthcheck |
|---|---|---|---|---|
| RSSHub | repo `/services/rsshub` (`FROM diygod/rsshub:chromium-bundled-2026-11-24@sha256:54998d18…198e`, ~0.5 GB compressed) | domain → 1200 | none | `/` (the only non-static path open without the key), 600 s |
| Redis | `redis:8.2.11@sha256:b0b01167…c8d` | no | `/data` | — |

No required inputs.

## Start sequence (`railway-rsshub.sh`)

1. `ACCESS_KEY` under 16 characters (incl. empty) → random key nobody knows + log hint (never open).
2. Invalid `PORT` → 1200.
3. `exec npm run start` (image default) under `dumb-init`.

## Improvements over market templates

Market (2026-11): "RSSHub | Open Source RSS Generator" 117 active, "RSSHub [Updated Nov ’26]" 161 active and "RSSHub | Convert any website to RSS" 52 active all run without `ACCESS_KEY` (an open fetching proxy on the internet), on `:latest`/`chromium-bundled` floating tags, two of them without a healthcheck; one exposes Redis through a public TCP proxy.

- `ACCESS_KEY` always on (generated, fail-closed on odd values).
- Pinned dated build by digest; Chromium bundled (upstream's browserless sidecar is SSPL-licensed and not needed).
- `TZ=UTC` instead of the image's Asia/Shanghai; debug info hidden; robots disallowed; logs to stdout only.
- Redis private only, `family=0` URL for IPv4/IPv6.

## Resources

Measured on Railway 2026-11-24 (idle after a few feeds):

| Service | RAM | CPU |
|---|---|---|
| RSSHub | 0.17-0.30 GB | ~0.01 vCPU idle |
| Redis | 0.05 GB | ~0 |

Total ≈ 0.25-0.35 GB ≈ **$3-4/month**. Prices: RAM $10/GB-month, vCPU $20/month, volume $0.15/GB-month. Minimum plan: Trial.

## Verification checklist

1. Both services SUCCESS; `/` 200.
2. A feed without key → 403 "Authentication failed"; with `?key=` → 200 RSS; with `?code=md5(path+key)` → 200.
3. Second request served from Redis cache (`X-Cache` / faster response; keys in Redis).
4. `ACCESS_KEY=abc` → SUCCESS with warning; feeds locked (`?key=abc` 403).

Tested 2026-11-24 on Railway: 1; 2 (`/hackernews`, `/github/issue/DIYgod/RSSHub`, `/github/repos/node-red` 200 with key and with `code`, 403 without/wrong key; `/healthz` is behind the key too, hence healthcheck `/`); 3 (first fetch 0.5-1.1 s, cached 0.25 s); 4. Not tested: a browser-rendered (Playwright) route.

## Open questions

- Routes that need site cookies/tokens are not configured (user's own accounts, at their discretion).
