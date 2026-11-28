# OmniRoute

Docker Compose setup for [OmniRoute](https://hub.docker.com/r/diegosouzapw/omniroute) (`diegosouzapw/omniroute:latest`), configured to connect to the shared `redis` container over the external `redis` Docker network.

## Prerequisites

- Docker and Docker Compose
- The `redis` stack running (creating the external `redis` Docker network and Redis instance)

## Getting Started

1. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `omniroute/.env` with a generated `INITIAL_PASSWORD`:
   ```bash
   ./scripts/setup.sh omniroute
   ```
   or
   ```bash
   cp .env.example .env
   ```
   copy the `.env.example` file to `.env` and edit it manually.

2. **Start the service:**
   ```bash
   cd omniroute
   docker compose up -d
   ```

3. **Open OmniRoute:**
   Visit `http://127.0.0.1:20128` in your browser.

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `omniroute` | `omniroute` | OmniRoute dashboard (`:20128`), API (`:20129`), and Live-WS (`:20132`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `DASHBOARD_PORT` | `20128` | Host and container port for the OmniRoute dashboard. |
| `API_PORT` | `20129` | Host and container port for the OmniRoute API. |
| `LIVE_WS_PORT` | `20132` | Host and container port for the Live WebSocket endpoint. |
| `APP_BIND_HOST` | `127.0.0.1` | Host IP address to bind published ports. Keep `127.0.0.1` unless `REQUIRE_API_KEY=true` or behind an auth-enforcing reverse proxy. |
| `REQUIRE_API_KEY` | `true` | Requires an API key / dashboard login on all requests. |
| `INITIAL_PASSWORD` | Generated (`alnum\|16`) | Initial dashboard password created on first boot. |
| `OMNIROUTE_MEMORY_MB` | `2048` | V8 old-space memory ceiling in MB. |
| `NEXT_PUBLIC_BASE_URL` | `https://your-domain.example.com` | Browser-facing origin when exposed behind a reverse proxy. |
| `BASE_URL` | `http://omniroute:20128` | Internal base URL for OmniRoute. |

### `compose.yml` Parameters

- **`omniroute` service (`omniroute`)**:
  - `image`: Uses `diegosouzapw/omniroute:latest` with `restart: unless-stopped` and `stop_grace_period: 40s`.
  - `env_file` & `environment`: Loads `.env` and sets `DATA_DIR=/app/data` and `REDIS_URL=redis://redis:6379`.
  - `ports`: Publishes `${APP_BIND_HOST:-127.0.0.1}` for `DASHBOARD_PORT` (`20128`), `API_PORT` (`20129`), and `LIVE_WS_PORT` (`20132`).
  - `volumes`: Mounts `./data:/app/data` for persistent SQLite storage and server state.
  - `networks`: Joins the external `redis` network.
  - `healthcheck`: Runs `node healthcheck.mjs` every 30s (`start_period: 20s`).

## Useful Commands

```bash
# View logs
docker compose logs -f omniroute

# Stop services
docker compose down
```
