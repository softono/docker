# qBittorrent + WebDAV

Docker Compose setup for [qBittorrent with WebDAV](https://hub.docker.com/r/mhdzumair/qbittorrent-webdav) (`mhdzumair/qbittorrent-webdav:latest`) with persistent configuration and downloads directories.

## Prerequisites

- Docker and Docker Compose

## Getting Started

1. **Start the service:**
   ```bash
   cd qbit
   docker compose up -d
   ```

2. **Open qBittorrent:**
   Visit `http://127.0.0.1:8081` (or `http://<server-ip>:8081`) in your browser. Check the container logs if you need the initial temporary WebUI password.

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `qbit` | `qbit` | qBittorrent WebUI (`:8081`) & BitTorrent peer port (`6881` TCP/UDP) |

## Documentation

### `compose.yml` Parameters

- **`qbit` service (`qbit`)**:
  - `image`: Uses `mhdzumair/qbittorrent-webdav:latest` with `restart: unless-stopped`.
  - `environment`: Sets `QBT_WEBUI_PORT=8081`.
  - `ports`:
    - `8081:8081` for the WebUI.
    - `6881:6881` and `6881:6881/udp` for incoming BitTorrent traffic.
  - `volumes`:
    - `./data/config:/config`: Persists qBittorrent settings and torrent state.
    - `./data/downloads:/downloads`: Stores downloaded files (also mounted by the `jellyfin` stack).

## Useful Commands

```bash
# View logs (including initial WebUI password)
docker compose logs -f qbit

# Stop services
docker compose down
```
