# Hermes

Docker Compose setup for running the official Hermes agent gateway and built-in web dashboard (`nousresearch/hermes-agent:latest`).

> For building from local source instead, see [`../hermes_build`](../hermes_build).

## Prerequisites

- Docker and Docker Compose

## Getting Started

1. **Configure environment variables:**
   Run the root setup script to generate `.env` with random secrets, or copy `hermes/.env.example` to `hermes/.env` manually:
   ```powershell
   .\scripts\setup.ps1 hermes
   ```
   Or manually:
   ```bash
   cp hermes/.env.example hermes/.env
   ```

2. **Start the service:**
   ```bash
   cd hermes
   docker compose up -d
   ```

3. **Access the Dashboard:**
   Open [http://127.0.0.1:9119/](http://127.0.0.1:9119/) and sign in using `HERMES_USERNAME` and `HERMES_PASSWORD` from `hermes/.env`.

## Services

| Service | Container | Ports | Purpose |
| --- | --- | --- | --- |
| `gateway` | `hermes` | `8642`, `9119` | Hermes agent gateway (`gateway run`) + built-in web dashboard |

## Documentation

### Environment Variables (`.env.example` / `.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `HERMES_UID` | `10000` | UID used inside the container. |
| `HERMES_GID` | `10000` | GID used inside the container. |
| `API_SERVER_KEY` | `generate_random_key:alnum\|32` | API key for authenticating gateway API requests. |
| `HERMES_USERNAME` | `creator` | Username for Hermes dashboard basic auth (`HERMES_DASHBOARD_BASIC_AUTH_USERNAME`). |
| `HERMES_PASSWORD` | `generate_random_key:alnum\|24` | Password for Hermes dashboard basic auth (`HERMES_DASHBOARD_BASIC_AUTH_PASSWORD`). |
| `HERMES_AUTH_SECRET` | `generate_random_key:base64\|32` | Secret used for Hermes auth signing. |

## Useful Commands

```bash
# View logs
docker compose logs -f gateway

# Pull latest image and restart
docker compose pull && docker compose up -d

# Stop services
docker compose down
```
