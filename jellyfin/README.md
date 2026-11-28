# Jellyfin

Docker Compose setup for [Jellyfin](https://jellyfin.org/) (`jellyfin/jellyfin:latest`) media server with local configuration and host media mounts.

## Prerequisites

- Docker and Docker Compose
- Host media directories available at `/media/creator/hdd/media` and `/www/wwwroot/app/qbit/data/downloads` (adjust volume paths in `compose.yml` if your media lives elsewhere)

## Getting Started

1. **Start the service:**
   ```bash
   cd jellyfin
   docker compose up -d
   ```

2. **Open Jellyfin:**
   Visit `http://127.0.0.1:8096` (or `http://<server-ip>:8096`) in your browser to complete the initial setup wizard.

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `jellyfin` | `jellyfin` | Jellyfin media server & web UI (`:8096`) |

## Documentation

### `compose.yml` Parameters

- **`jellyfin` service (`jellyfin`)**:
  - `image`: Uses `jellyfin/jellyfin:latest` with `restart: unless-stopped`.
  - `ports`: Publishes `8096:8096` for the Jellyfin web UI and API.
  - `environment`: Sets `TZ=Asia/Kolkata`.
  - `volumes`:
    - `./data:/config`: Persists Jellyfin configuration, metadata, and database.
    - `/media/creator/hdd/media:/media/hdd/media:rw`: Mounts the main media library.
    - `/www/wwwroot/app/qbit/data/downloads:/media/downloads:rw`: Mounts the `qbit` downloads folder so downloaded media can be indexed directly.

## Useful Commands

```bash
# View logs
docker compose logs -f jellyfin

# Stop services
docker compose down
```
