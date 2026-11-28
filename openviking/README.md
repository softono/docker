# OpenViking

Docker Compose setup for [OpenViking](https://github.com/volcengine/OpenViking) (`ghcr.io/volcengine/openviking:latest`), including the server, VikingBot, web console UI, and optional MCP gateway.

## Prerequisites

- Docker and Docker Compose
- An `ov.conf` file in `openviking/ov.conf` for model providers and authentication

## Getting Started

1. **Create `ov.conf`:**
   Create `openviking/ov.conf` with your model provider and authentication configuration before starting the container.

2. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `openviking/.env` with a generated `OPENVIKING_GATEWAY_MANAGEMENT_KEY`, and set `OPENVIKING_PUBLIC_BASE_URL`:
   ```bash
   bash scripts/setup.sh openviking
   ```

3. **Start the service:**
   ```bash
   cd openviking
   docker compose up -d
   ```

4. **Open OpenViking:**
   Visit `http://127.0.0.1:8084` (using `.env` defaults) or `http://127.0.0.1:1933` (Compose fallback) in your browser.

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `openviking` | `memory` | OpenViking server, VikingBot & web console UI (`127.0.0.1:8084`), plus optional MCP gateway (`127.0.0.1:8085`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `OPENVIKING_SERVER_PORT` | `8084` (Compose fallback `1933`) | Port the OpenViking HTTP server listens on and exposes on `127.0.0.1`. |
| `OPENVIKING_PUBLIC_BASE_URL` | `https://memory.example.com` | Public URL used for CORS, link generation, and OAuth redirects. |
| `OPENVIKING_GATEWAY_ENABLED` | `false` | Enables the built-in MCP gateway when `true`. |
| `OPENVIKING_GATEWAY_PORT` | `8085` (Compose fallback `1934`) | Host and container port for the optional MCP gateway. |
| `OPENVIKING_GATEWAY_MANAGEMENT_KEY` | Generated (`base64\|32`) | Secret key used to authenticate gateway management requests. |
| `OPENVIKING_GATEWAY_ENCRYPTION_KEY` | *(empty)* | Legacy encryption key for migrating v0.5.0 gateway data; remove after first startup. |

### `compose.yml` Parameters

- **`openviking` service (`memory`)**:
  - `image`: Uses `ghcr.io/volcengine/openviking:latest` with `restart: unless-stopped`.
  - `ports`: Publishes `127.0.0.1:${OPENVIKING_SERVER_PORT:-1933}:${OPENVIKING_SERVER_PORT:-1933}` and `127.0.0.1:${OPENVIKING_GATEWAY_PORT:-1934}:${OPENVIKING_GATEWAY_PORT:-1934}`.
  - `volumes`:
    - `./data:/app/.openviking`: Persistent indexes, RAGFS files, and SQLite metadata.
    - `./ov.conf:/root/.openviking/ov.conf:ro`: Read-only provider and auth configuration.
  - `env_file` & `environment`: Loads `.env` and passes server and gateway configuration variables.

## Useful Commands

```bash
# View logs
docker compose logs -f openviking

# Stop services
docker compose down
```
