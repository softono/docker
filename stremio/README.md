# Stremio Server

Docker Compose setup for [Stremio Server](https://hub.docker.com/r/stremio/server) (`stremio/server:latest`) with persistent local state.

## Prerequisites

- Docker and Docker Compose

## Getting Started

1. **Start the service:**
   ```bash
   cd stremio
   docker compose up -d
   ```

2. **Connect to Stremio Server:**
   Point your Stremio client or browser to `http://127.0.0.1:11470` (or `http://<server-ip>:11470`).

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `stremio` | `stremio` | Stremio streaming server (`:11470`) |

## Documentation

### `compose.yml` Parameters

- **`stremio` service (`stremio`)**:
  - `image`: Uses `stremio/server:latest` with `restart: unless-stopped`.
  - `ports`: Publishes `11470:11470`.
  - `environment`: Sets `NO_CORS=1`.
  - `volumes`: Mounts `./data:/root/.stremio-server` for persistent server cache and settings.

## Useful Commands

```bash
# View logs
docker compose logs -f stremio

# Stop services
docker compose down
```
