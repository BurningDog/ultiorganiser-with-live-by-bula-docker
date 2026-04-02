# uo-with-live-docker

Docker setup for running [uo-with-live-1.9.16](uo-with-live-1.9.16/) (UltiOrganizer + Live! by BULA 1.9.16).

Download the 1.9.16 release from [https://github.com/layoutd/live-by-bula/releases/tag/v1.9.16](https://github.com/layoutd/live-by-bula/releases/tag/v1.9.16) and unzip into a folder named `uo-with-live-1.9.16`. This is so that the Dockerfile can copy the correct folder into the container.

## Usage


```bash
docker compose up --build
```

Then visit http://localhost:8081/install.php to complete the UltiOrganizer setup.

Use these values on the install form:

| Field    | Value         |
| -------- | ------------- |
| Hostname | `db`          |
| Username | `ultiorganizer` |
| Password | `ultiorganizer` |
| Database | `ultiorganizer` |

After UltiOrganizer is set up, follow the Live! by BULA setup instructions in [../uo-with-live-1.9.16/live/README.md](../uo-with-live-1.9.16/live/README.md).

## Design decisions

**PHP 7.4-apache** — matches the Composer minimum declared by Live! by BULA; uses the official `php:7.4-apache` image which bundles Apache.

**MySQL 8.0** with `--default-authentication-plugin=mysql_native_password` — required for older PHP mysqli to connect without authentication errors. MySQL 8 changed the default auth plugin to `caching_sha2_password`, which breaks legacy clients.

**Build context is `..`** (the `ultimate-frisbee/` parent directory) so Docker can `COPY uo-with-live-1.9.16/` into the image. Docker build contexts cannot reference parent directories, so the context must be widened to the parent.

**Port 8081** — avoids clashing with the main `ultiorganizer` container which uses 8080.

**`AllowOverride All`** — patched into the Apache config via `sed` so the existing `.htaccess` URL rewriting works correctly.

**`images/uploads/`** — created in the image at build time; the directory does not exist in the source tree but `install.php` defaults to it as the upload path.

**Writable directories** — five directories need to be writable by PHP at runtime. Four are mapped to Docker volumes so data survives container recreation; one is left ephemeral:

| Directory         | Contents                                                                             | Volume                                     |
| ----------------- | ------------------------------------------------------------------------------------ | ------------------------------------------ |
| `conf/`           | UltiOrganizer `config.inc.php` written by `install.php` (DB credentials, settings)  | `uo-conf`                                  |
| `images/uploads/` | User-uploaded images (team logos, player photos)                                     | `${UPLOADS_FOLDER}` (bind mount, set in `.env`) |
| `live/conf/`      | Live! by BULA `local-config.json` written by the admin panel (season, URLs, theme)  | `live-conf`                                |
| `live/teams/`     | Team photo `.jpg` files uploaded for Live! by BULA team pages                        | `live-teams`                               |
| `live/data/`      | File-based JSON cache — auto-regenerated from the DB on every request                | None (ephemeral)                           |
