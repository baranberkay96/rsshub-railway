# RSSHub (AGPL-3.0), official image with bundled Chromium for Playwright routes, unmodified,
# pinned by digest (RSSHub publishes rolling date tags; this is the build of 2026-11-24,
# ~0.5 GB compressed amd64), plus a start script that keeps ACCESS_KEY always on.
ARG RSSHUB_IMAGE=diygod/rsshub:chromium-bundled-2026-11-24@sha256:54998d187e74780ee46f359e13b0e5b339b4c6c149daddb71e71ec88122e198e
FROM ${RSSHUB_IMAGE}

COPY --chmod=0755 railway-rsshub.sh /usr/local/bin/railway-rsshub.sh

ENV PORT=1200
ENTRYPOINT ["dumb-init", "--"]
CMD ["/usr/local/bin/railway-rsshub.sh"]
