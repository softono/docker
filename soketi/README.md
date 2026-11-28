# Soketi

Docker Compose setup for [Soketi](https://github.com/soketi/soketi) (`quay.io/soketi/soketi:latest-16-alpine`), a Pusher-compatible WebSocket server with Prometheus metrics and its own `soketi` Docker network.

## Prerequisites

- Docker and Docker Compose

## Getting Started

1. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `soketi/.env` with generated `SOKETI_DEFAULT_APP_ID`, `SOKETI_DEFAULT_APP_KEY`, and `SOKETI_DEFAULT_APP_SECRET` values:
   ```bash
   bash scripts/setup.sh soketi
   ```

2. **Start the service:**
   ```bash
   cd soketi
   docker compose up -d
   ```

3. **Verify Soketi:**
   - WebSocket endpoint: `ws://127.0.0.1:6001`
   - Metrics endpoint: `http://127.0.0.1:9601/metrics`

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `soketi` | `soketi` | Pusher-compatible WebSocket server (`127.0.0.1:6001`) & metrics (`127.0.0.1:9601`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `SOKETI_BIND_HOST` | `127.0.0.1` | Host IP address to bind published ports. |
| `SOKETI_PORT` | `6001` | Host port mapped to Soketi's WebSocket port `6001`. |
| `SOKETI_METRICS_PORT` | `9601` | Host port mapped to Soketi's metrics port `9601`. |
| `SOKETI_METRICS_ENABLED` | `1` | Enables the Prometheus metrics server (`1` = enabled, `0` = disabled). |
| `SOKETI_DEBUG` | `0` | Enables debug logging (`1` = enabled, `0` = disabled). |
| `SOKETI_DEFAULT_APP_ID` | Generated (`alnum\|16`) | Default Pusher app ID. |
| `SOKETI_DEFAULT_APP_KEY` | Generated (`alnum\|32`) | Default Pusher app key. |
| `SOKETI_DEFAULT_APP_SECRET` | Generated (`alnum\|32`) | Default Pusher app secret. |

### `compose.yml` Parameters

- **`soketi` service (`soketi`)**:
  - `image`: Uses `quay.io/soketi/soketi:latest-16-alpine` with `restart: unless-stopped`.
  - `ports`: Publishes `${SOKETI_BIND_HOST:-127.0.0.1}:${SOKETI_PORT:-6001}:6001` and `${SOKETI_BIND_HOST:-127.0.0.1}:${SOKETI_METRICS_PORT:-9601}:9601`.
  - `env_file` & `environment`: Loads `.env` and sets `SOKETI_PORT=6001`, `SOKETI_METRICS_SERVER_PORT=9601`, and app credentials.
  - `networks`: Joins the `soketi` bridge network (`networks.soketi.name: soketi`).

## Useful Commands

```bash
# View logs
docker compose logs -f soketi

# Stop services
docker compose down
```
