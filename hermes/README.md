# Hermes

Docker Compose setup for building and running the Hermes agent gateway (`hermes-agent:local`) from `./source` using host networking.

## Prerequisites

- Docker and Docker Compose
- Local source repository placed in `hermes/source` containing a `Dockerfile`

## Getting Started

1. **Configure environment variables:**
   Copy `hermes/.env.examle` to `hermes/.env` and replace the placeholder secrets (`API_SERVER_KEY`, `HERMES_PASSWORD`, `HERMES_AUTH_SECRET`):
   ```bash
   cp hermes/.env.examle hermes/.env
   ```

2. **Build and start the service:**
   ```bash
   cd hermes
   docker compose up -d --build
   ```

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `gateway` | `hermes` | Hermes agent gateway (`gateway run`, host network) |

## Documentation

### Environment Variables (`.env.examle` / `.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `HERMES_UID` | `10000` | UID used inside the container. |
| `HERMES_GID` | `10000` | GID used inside the container. |
| `API_SERVER_KEY` | `YOUR_RANDOM_API_KEY` | API key for authenticating gateway API requests. |
| `HERMES_USERNAME` | `creator` | Username for Hermes authentication. |
| `HERMES_PASSWORD` | `YOUR_STRONG_PASSWORD` | Password for Hermes authentication. |
| `HERMES_AUTH_SECRET` | `YOUR_RANDOM_SECRET` | Secret used for Hermes auth signing. |

### `compose.yml` Parameters

- **`gateway` service (`hermes`)**:
  - `build`: Builds from `./source` using `./source/Dockerfile` and tags the image as `hermes-agent:local`.
  - `network_mode: host`: Shares the host network stack directly.
  - `volumes`: Mounts `./data:/opt/data` for persistent data.
  - `environment`: Sets `HERMES_UID`, `HERMES_GID`, `API_SERVER_HOST=0.0.0.0`, and `API_SERVER_KEY`.
  - `command`: Runs `["gateway", "run"]`.
  - `restart`: `unless-stopped`.

## Useful Commands

```bash
# View logs
docker compose logs -f gateway

# Rebuild and restart
docker compose up -d --build

# Stop services
docker compose down
```
