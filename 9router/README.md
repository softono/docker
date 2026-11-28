# 9Router

Docker Compose setup for [9Router](https://hub.docker.com/r/decolua/9router) (`decolua/9router:latest`), bound to localhost with persistent local storage.

## Prerequisites

- Docker and Docker Compose

## Getting Started

1. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to generate `9router/.env` with random `INITIAL_PASSWORD` and `JWT_SECRET` values:
   ```bash
   ./scripts/setup.sh 9router
   ```
   or
   ```bash
   cp .env.example .env
   ```
   copy the `.env.example` file to `.env` and edit it manually.

2. **Start the service:**
   ```bash
   cd 9router
   docker compose up -d
   ```

3. **Open 9Router:**
   Visit `http://127.0.0.1:20120` in your browser.

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `9router` | `9router` | 9Router server & web UI (`127.0.0.1:20120`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `INITIAL_PASSWORD` | Generated (`alnum\|16`) | Initial login password for the 9Router dashboard. |
| `JWT_SECRET` | Generated (`base64\|32`) | Secret key used to sign authentication JWTs. |
| `AUTH_COOKIE_SECURE` | `true` | Marks authentication cookies with the `Secure` flag (requires HTTPS when accessed through a reverse proxy). |
| `REQUIRE_API_KEY` | `true` | Requires an API key for incoming requests. |

### `compose.yml` Parameters

- **`9router` service**:
  - `image`: Uses `decolua/9router:latest` with `restart: unless-stopped`.
  - `ports`: Publishes `127.0.0.1:20120:20120` so the service is only accessible on localhost.
  - `volumes`: Mounts `./data:/app/data` for persistent state, catalog, and configuration files.
  - `env_file` & `environment`: Loads `.env` and sets `DATA_DIR=/app/data`, `PORT=20120`, `HOSTNAME=0.0.0.0`, and `NODE_ENV=production`.

## Useful Commands

```bash
# View logs
docker compose logs -f 9router

# Stop services
docker compose down
```
