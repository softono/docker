# n8n

Docker Compose setup for [n8n](https://n8n.io/) (`docker.n8n.io/n8nio/n8n:latest`), configured to use an external PostgreSQL database over the `postgres` Docker network.

## Prerequisites

- Docker and Docker Compose
- The `postgres` stack running (or a PostgreSQL instance reachable at `POSTGRESDB_HOST` and an external `postgres` Docker network)

## Getting Started

1. **Create the `n8n` database and user** in your running `postgres` container (once):
   ```bash
   docker exec -it postgres psql -U postgres -c "CREATE USER n8n_user WITH ENCRYPTED PASSWORD 'CHANGE_THIS_TO_YOUR_POSTGRES_PASSWORD';"
   docker exec -it postgres psql -U postgres -c "CREATE DATABASE n8n OWNER n8n_user;"
   ```

2. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `n8n/.env` with a generated `N8N_ENCRYPTION_KEY`, then set `N8N_HOST`, `POSTGRESDB_HOST` (e.g. `postgres` if using the `postgres` container), and `POSTGRESDB_PASSWORD`:
   ```bash
   ./scripts/setup.sh n8n
   ```
   or
   ```bash
   cp .env.example .env
   ```
   copy the `.env.example` file to `.env` and edit it manually.

3. **Start the service:**
   ```bash
   cd n8n
   docker compose up -d
   ```

4. **Open n8n:**
   Visit `http://127.0.0.1:5678` in your browser (or your configured `https://${N8N_HOST}/` reverse proxy URL).

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `n8n` | `n8n` | n8n workflow automation server & web UI (`127.0.0.1:5678`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `N8N_HOST` | `n8n.example.com` | Public hostname used for `N8N_HOST` and `WEBHOOK_URL` (`https://${N8N_HOST}/`). |
| `TZ` | `Asia/Kolkata` | Timezone applied to both `TZ` and `GENERIC_TIMEZONE`. |
| `POSTGRESDB_HOST` | `host.docker.internal` | PostgreSQL hostname (use `postgres` when connecting to the `postgres` container). |
| `POSTGRESDB_PORT` | `5432` | PostgreSQL port. |
| `POSTGRESDB_DATABASE` | `n8n` | PostgreSQL database name. |
| `POSTGRESDB_USER` | `n8n_user` | PostgreSQL username. |
| `POSTGRESDB_PASSWORD` | `CHANGE_THIS_TO_YOUR_POSTGRES_PASSWORD` | PostgreSQL password. |
| `N8N_ENCRYPTION_KEY` | Generated (`alnum\|64`) | Encryption key for stored n8n credentials. |

### `compose.yml` Parameters

- **`n8n` service (`n8n`)**:
  - `image`: Uses `docker.n8n.io/n8nio/n8n:latest` with `restart: unless-stopped`.
  - `ports`: Publishes `127.0.0.1:5678:5678` so n8n is only accessible on localhost.
  - `environment`: Configures `DB_TYPE=postgresdb`, `N8N_PROTOCOL=https`, `N8N_PORT=5678`, `WEBHOOK_URL`, and timezone variables.
  - `volumes`: Uses named volume `n8n_data:/home/node/.n8n` for persistent workflows and settings.
  - `networks`: Joins `default` and the external `postgres` network.

## Useful Commands

```bash
# View logs
docker compose logs -f n8n

# Stop services
docker compose down
```
