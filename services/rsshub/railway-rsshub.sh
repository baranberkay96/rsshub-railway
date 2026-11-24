#!/bin/sh
# Railway start script for RSSHub (official chromium-bundled image, unmodified).
# - ACCESS_KEY is always on: an empty or short key (under 16 characters) is replaced by a
#   random one nobody knows, so the instance never runs as an open proxy; the log says how
#   to fix it. Feeds then need ?key=ACCESS_KEY (or ?code=...), see README.
# - An invalid PORT falls back to 1200 instead of failing the deploy (STANDARD 8.29).
# Secret values are never printed.
log() { echo "[railway] $*"; }
warn() { echo "[railway] WARNING: $*" >&2; }

key="${ACCESS_KEY:-}"
if [ "${#key}" -lt 16 ]; then
  warn "ACCESS_KEY is empty or shorter than 16 characters. All feeds stay locked with a random key nobody knows; set ACCESS_KEY (16+ characters) on the RSSHub service and redeploy."
  ACCESS_KEY="$(head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n')"
  export ACCESS_KEY
fi

case "${PORT:-}" in
  ''|*[!0-9]*) [ -n "${PORT:-}" ] && warn "PORT=${PORT} is not a number; using 1200"; PORT=1200 ;;
esac
if [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then warn "PORT=${PORT} is out of range; using 1200"; PORT=1200; fi
export PORT

log "starting RSSHub on port ${PORT} (access key required for feeds)"
exec npm run start
