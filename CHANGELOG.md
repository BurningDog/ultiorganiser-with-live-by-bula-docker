# Changelog

## Configuration improvements — 2026-04-03

Made the web port configurable via a `WEBSITE_PORT` environment variable rather than hardcoding `8081` in `docker-compose.yaml`. Improved `.env.example` layout with section headings separating MySQL config from folder config. Added `.env` and `.DS_Store` to `.gitignore`.

## Initial Docker setup — 2026-04-03

Added `Dockerfile`, `docker-compose.yaml`, `README.md`, `.env.example`, and `.gitignore` to set up the containerised environment for running UltiOrganizer + Live! by BULA 1.9.16.

- PHP 7.4-apache image with `mysqli`, `gettext`, `gd`, and `mbstring` extensions
- MySQL 8.0 with `mysql_native_password` auth for compatibility with the legacy codebase
- MySQL healthcheck with `depends_on: condition: service_healthy` so the web container waits for the DB to be ready
- `restart: unless-stopped` on both services
- Named volumes for persistent data: `uo-conf` (UO config), `live-conf` (Live! by BULA config), `live-teams` (team photos); bind mounts for uploads and DB data via `.env`
- `live/data/` left ephemeral (cache only, auto-regenerated)
- `AllowOverride All` patched into Apache config to enable `.htaccess` URL rewriting
- `uo-with-live-1.9.16/` added to `.gitignore` (must be downloaded separately)
