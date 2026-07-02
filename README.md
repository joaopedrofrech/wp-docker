# WP-Docker

WP Docker is a clean, production-focused WordPress stack for people who want fast setup, predictable versions, and simple operations. It ships with two compose options: a SQLite-first setup for lightweight deployments, and a MariaDB setup when you need a separate database service.

Everything is designed to stay practical: fixed image tags, persistent Docker volumes, Nginx + PHP-FPM, and built-in utilities for file and database access.

## Stack Components

| Component | Version | Notes |
|---|---|---|
| WordPress (SQLite compose) | ghcr.io/yunussandikci/wordpress-sqlite:php8.5-fpm | Main app with SQLite integration |
| WordPress (MariaDB compose) | wordpress:fpm | Main app for external DB mode |
| Nginx | nginx:1.28-alpine | Web server |
| File Browser | filebrowser/filebrowser:v2.62.2-s6 | File management |
| Adminer | adminer-5.4.2.php | Database management |
| MariaDB | mariadb:11.8-noble | Used only in MariaDB compose |

## Compose Modes

- SQLite mode: docker-compose.yml
- MariaDB mode: docker-compose.mariadb.yml

Use one mode at a time.

## Dokploy Start

This project is designed to run directly in Dokploy for production.

1. Deploy this repository in Dokploy.
2. Choose one compose file:
   - `docker-compose.yml` (SQLite)
   - `docker-compose.mariadb.yml` (MariaDB)
3. Configure environment variables from `.env.example`.
4. Configure your Nginx route for your main domain and SSL in Dokploy.
5. Configure a File Browser route in Dokploy pointing to `files.domain.com`.
6. Configure a Nginx route in Dokploy pointing to `db.domain.com`.
7. Deploy the stack.

## Local Start (Without Dokploy)

Use only one mode at a time: SQLite OR MariaDB.

Copy env file:

```bash
cp .env.example .env
```

Edit `.env` and set your passwords.

Option A - Start SQLite stack:

```bash
docker compose up -d
```

Option B - Start MariaDB stack:

```bash
docker compose -f docker-compose.mariadb.yml up -d
```

Stop SQLite stack (if Option A was used):

```bash
docker compose down
```

Stop MariaDB stack (if Option B was used):

```bash
docker compose -f docker-compose.mariadb.yml down
```

## Access

- WordPress: domain.com
- File Browser: files.domain.com
- Adminer: db.domain.com

## Cloudflare Integration

WP-Docker is designed to run behind Cloudflare with full integration:

- DNS: use Cloudflare as your authoritative DNS.
- CDN: keep proxy enabled to use edge caching and global delivery.
- Firewall: use WAF and rate limiting for public routes.
- Cache: use [Super Page Cache for Cloudflare](https://wordpress.org/plugins/wp-cloudflare-page-cache/) in WordPress.

Recommended security hardening:

- Protect `files.domain.com` with Traefik Middleware or Cloudflare Zero Trust.
- Protect `db.domain.com` with Traefik Middleware or Cloudflare Zero Trust.

## Notes

- Image tags are intentionally fixed for predictable deployments.
- File Browser healthcheck is disabled by design.
- Data is persisted in named Docker volumes.
