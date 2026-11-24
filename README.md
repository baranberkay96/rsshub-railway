# Deploy and Host RSSHub with Railway

RSSHub turns websites, social profiles, forums and release pages that have no feed into RSS, Atom or JSON feeds you can follow in any reader. This template runs RSSHub with a Redis cache, the Chromium-bundled image for JavaScript-heavy pages, and an access key that is always on.

## About Hosting RSSHub

RSSHub is a Node.js server with a large library of community-maintained routes: you request a path such as `/github/issue/DIYgod/RSSHub` and it fetches the source, builds a feed and caches it. Redis keeps the cache across restarts so sources are not hit on every reader refresh. The Chromium-bundled image lets routes that need a real browser render pages in the same container, without a separate browser service.

A public RSSHub without protection can be used by anyone as a fetching proxy. This template therefore always sets `ACCESS_KEY`: every feed URL must carry `?key=` or a per-route `?code=`. If the key is emptied or too short, feeds stay locked with a random key instead of opening up.

## Common Use Cases

- Follow GitHub releases and issues, YouTube channels, subreddits, podcasts and blogs in one RSS reader
- Feed news and updates into automations (n8n, Zapier, Slack bots, Discord webhooks)
- Monitor product pages, changelogs or forums that offer no notifications
- Run a private, cached feed endpoint for your own reader instead of a public instance

## Dependencies for RSSHub Hosting

- RSSHub rolling build of 2026-11-24 (`diygod/rsshub:chromium-bundled`, pinned by digest)
- Redis 8.2 as the feed cache

### Deployment Dependencies

- RSSHub source: https://github.com/DIYgod/RSSHub
- RSSHub documentation and route list: https://docs.rsshub.app
- Deployment options: https://docs.rsshub.app/deploy/config

### Implementation Details

| Service | What it does | Public |
|---|---|---|
| RSSHub | Feed server (port 1200) with bundled Chromium | yes |
| Redis | Route and content cache | no |

**Using feeds.** Take any route from the RSSHub docs and add your key, for example `https://{your-domain}/github/issue/DIYgod/RSSHub?key={ACCESS_KEY}`. The key is the `ACCESS_KEY` variable of the RSSHub service. To share a single feed without the key, use `?code=` with the MD5 of the route path plus the key (`md5('/github/issue/DIYgod/RSSHub' + key)`).

**Home page.** The public home page only shows that the instance runs; debug details are off (`DEBUG_INFO=false`) and search engines are asked not to index it.

**Routes needing accounts.** Some routes need cookies or API tokens of the source site (set as variables per the RSSHub docs). Only add credentials for accounts you own, and respect each site's terms of service and robots rules; this template configures none.

**Cache.** `CACHE_EXPIRE` (default 300 s) and `CACHE_CONTENT_EXPIRE` (3600 s) control how often sources are fetched. Longer values reduce load on sources and on your service.

**Scaling.** RSSHub is stateless; raise the replica count of the RSSHub service for many readers. All replicas share the Redis cache.

**Versions.** RSSHub has no numbered releases; the image is a dated build pinned in `services/rsshub/Dockerfile` (`RSSHUB_IMAGE`, tag and digest). To update, pick a newer `chromium-bundled-YYYY-MM-DD` tag and its digest from Docker Hub and redeploy.

**Resources.** About 0.2-0.4 GB RAM idle; browser-rendered routes add a few hundred MB while they run. Runs on Trial, Hobby and Pro.

**Licence.** RSSHub is AGPL-3.0. If you modify it and offer it over a network, publish your changes.

### Why Deploy RSSHub on Railway?

Railway runs RSSHub and its Redis cache from one template with private networking and a generated access key, so you get a private feed endpoint with HTTPS in minutes and only pay for what it uses.
