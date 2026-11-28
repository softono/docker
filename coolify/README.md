# Coolify

Docker Compose setup for [Coolify](https://coolify.io/) (`ghcr.io/coollabsio/coolify:latest`) and its realtime WebSocket server (`coolify-realtime`), configured to use the shared external `postgres` and `redis` Docker networks.

## Prerequisites

- Docker and Docker Compose
- The `postgres` stack running (providing the external `postgres` network and PostgreSQL instance)
- The `redis` stack running (providing the external `redis` network and Redis instance)

## Getting Started

1. **Create the `coolify` database and user** in your running `postgres` container (once):
   ```bash
   docker exec -it postgres psql -U postgres -c "CREATE USER coolify WITH ENCRYPTED PASSWORD 'CHANGE_THIS_TO_YOUR_POSTGRES_PASSWORD';"
   docker exec -it postgres psql -U postgres -c "CREATE DATABASE coolify OWNER coolify;"
   ```

2. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `coolify/.env` with generated `APP_KEY` and Pusher/Soketi credentials, then set `DB_PASSWORD` and `REDIS_PASSWORD`:
   ```bash
   bash scripts/setup.sh coolify
   ```

3. **Start the services:**
   ```bash
   cd coolify
   docker compose up -d
   ```

4. **Open Coolify:**
   Visit `http://127.0.0.1:8000` in your browser.

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `coolify` | `coolify` | Coolify web UI & control plane (`127.0.0.1:8000`) |
| `soketi` | `coolify-realtime` | Coolify realtime WebSocket & terminal server (`127.0.0.1:6001`, `127.0.0.1:6002`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `APP_NAME` | `Coolify` | Application display name passed to `soketi`. |
| `APP_ENV` | `production` | Laravel/Coolify runtime environment. |
| `APP_KEY` | Generated (`alnum\|32`) | Encryption key for Coolify. |
| `APP_BIND_HOST` | `127.0.0.1` | Host IP address to bind published ports. |
| `APP_PORT` | `8000` | Host port mapped to Coolify's internal port `8080`. |
| `DB_HOST` | `postgres` | PostgreSQL hostname on the external `postgres` network. |
| `DB_PORT` | `5432` | PostgreSQL port. |
| `DB_DATABASE` | `coolify` | PostgreSQL database name. |
| `DB_USERNAME` | `coolify` | PostgreSQL username. |
| `DB_PASSWORD` | `CHANGE_THIS_TO_YOUR_POSTGRES_PASSWORD` | PostgreSQL password. |
| `REDIS_HOST` | `redis` | Redis hostname on the external `redis` network. |
| `REDIS_PORT` | `6379` | Redis port. |
| `REDIS_PASSWORD` | `CHANGE_THIS_TO_YOUR_REDIS_PASSWORD` | Redis password. |
| `PUSHER_HOST` | `soketi` | Hostname of the `soketi` service for realtime events. |
| `PUSHER_PORT` | `6001` | Port of the `soketi` service. |
| `PUSHER_APP_ID` | Generated (`alnum\|32`) | Pusher/Soketi app ID shared between `coolify` and `soketi`. |
| `PUSHER_APP_KEY` | Generated (`alnum\|32`) | Pusher/Soketi app key. |
| `PUSHER_APP_SECRET` | Generated (`alnum\|32`) | Pusher/Soketi app secret. |
| `SOKETI_PORT` | `6001` | Host port mapped to `soketi` WebSocket port `6001`. |
| `SOKETI_TERMINAL_PORT` | `6002` | Host port mapped to `soketi` terminal port `6002`. |
| `SOKETI_DEBUG` | `false` | Enables Soketi debug logging when `true`. |
| `SOKETI_HOST` | `0.0.0.0` | Bind address for Soketi inside the container. |

### `compose.yml` Parameters

- **`coolify` service**:
  - `image`: `ghcr.io/coollabsio/coolify:latest`, `working_dir: /var/www/html`, `restart: unless-stopped`.
  - `ports`: Publishes `${APP_BIND_HOST:-127.0.0.1}:${APP_PORT:-8000}:8080`.
  - `volumes`: Mounts `./.env:/var/www/html/.env`, persistent `./data/*` directories (`ssh`, `applications`, `databases`, `backups`, `services`, `proxy`, `webhooks-during-maintenance`), and `/var/run/docker.sock:/var/run/docker.sock`.
  - `extra_hosts`: Maps `host.docker.internal` to `host-gateway`.
  - `depends_on`: Waits for `soketi` (`service_healthy`).
  - `networks`: Joins `coolify`, `postgres`, and `redis`.
- **`soketi` service (`coolify-realtime`)**:
  - `image`: `ghcr.io/coollabsio/coolify-realtime:1.0.12`.
  - `ports`: Publishes `${APP_BIND_HOST:-127.0.0.1}:${SOKETI_PORT:-6001}:6001` and `${APP_BIND_HOST:-127.0.0.1}:${SOKETI_TERMINAL_PORT:-6002}:6002`.
  - `volumes`: Shares `./data/ssh:/var/www/html/storage/app/ssh`.
  - `healthcheck`: Polls `http://localhost:6001/ready` with `wget` every 10s.
  - `networks`: Joins `coolify`.
- **`networks`**:
  - `coolify`: Bridge network named `coolify`.
  - `postgres` & `redis`: External networks.

## Useful Commands

```bash
# View logs
docker compose logs -f coolify soketi

# Stop services
docker compose down
```
