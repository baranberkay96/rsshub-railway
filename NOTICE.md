# Notice

This package deploys **RSSHub** (https://github.com/DIYgod/RSSHub), licensed under the **GNU Affero General Public License v3.0**. The image `diygod/rsshub:chromium-bundled-2026-11-24` is used unmodified as the base; its source is at the link above (build of commit f249d128, 2026-11-24). If you modify RSSHub and offer it to users over a network, the AGPL requires you to offer them your modified source.

What is used and how:

- `services/rsshub/railway-rsshub.sh` is original work for this template; it validates `ACCESS_KEY` and `PORT` and runs the image's own `npm run start`.
- Configuration follows upstream `docker-compose.yml`, `Dockerfile`, `lib/config.ts` and `lib/middleware/access-control.ts` (checked 2026-11-24).
- The optional `browserless` service of upstream's compose is not used (the Chromium-bundled image covers browser routes in one container).
- Redis service definition from Railway's official templates.
- Icon: selfh.st icons (https://github.com/selfhst/icons).

Market templates were read for comparison only; no files or text were copied. README and docs text are original.

This is a community template and is not affiliated with or endorsed by the RSSHub project.
