# TriliumNext

Docker Compose setup for [TriliumNext Notes](https://github.com/TriliumNext/trilium) (`ghcr.io/triliumnext/trilium:latest`), bound to localhost for use behind a reverse proxy.

## Prerequisites

- Docker and Docker Compose (Linux; on Windows/macOS, remove the `/etc/localtime:/etc/localtime:ro` volume mount from `compose.yml` and rely on `TZ`)

## Getting Started

1. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `trilium/.env`, then update `TRILIUM_PUBLIC_URL` (and `TRILIUM_PORT` / `TRILIUM_INSTANCE_NAME` if needed):
   ```bash
   bash scripts/setup.sh trilium
   ```

2. **Start the service:**
   ```bash
   cd trilium
   docker compose up -d
   ```

3. **Open TriliumNext:**
   Visit `http://127.0.0.1:8082` (or your configured `TRILIUM_PORT` / reverse proxy URL) in your browser.

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `trilium` | `notes` | TriliumNext note-taking server & web UI (`127.0.0.1:8082`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `TZ` | `Asia/Kolkata` | Container timezone. |
| `TRILIUM_PORT` | `8082` (Compose fallback `8080`) | Host and container listener port (`TRILIUM_NETWORK_PORT`). |
| `TRILIUM_PUBLIC_URL` | `https://notes.example.com` | Public URL used for `TRILIUM_NETWORK_CORSALLOWORIGIN`. |
| `TRILIUM_INSTANCE_NAME` | `Notes` | Display name shown in the browser tab and UI header (`TRILIUM_GENERAL_INSTANCENAME`). |
| `TRILIUM_NETWORK_TRUSTEDREVERSEPROXY` | `loopback` | Trusted proxy setting for `X-Forwarded-For` (`loopback` for host Nginx/Apache, or a Docker subnet like `172.18.0.0/16`). |

### `compose.yml` Parameters

- **`trilium` service (`notes`)**:
  - `image`: Uses `ghcr.io/triliumnext/trilium:latest` with `restart: unless-stopped`.
  - `ports`: Publishes `127.0.0.1:${TRILIUM_PORT:-8080}:${TRILIUM_PORT:-8080}` so Trilium is only accessible on localhost.
  - `volumes`:
    - `./data:/home/node/trilium-data`: Persists the SQLite database, `config.ini`, and automatic backups.
    - `/etc/localtime:/etc/localtime:ro`: Syncs host timezone on Linux.
  - `env_file` & `environment`: Loads `.env` and maps variables to `TRILIUM_NETWORK_*` and `TRILIUM_GENERAL_INSTANCENAME`.

## Useful Commands

```bash
# View logs
docker compose logs -f trilium

# Stop services
docker compose down
```
