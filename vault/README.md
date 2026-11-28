# Vaultwarden

Docker Compose setup for [Vaultwarden](https://github.com/dani-garcia/vaultwarden) (`vaultwarden/server:latest-alpine`), bound to localhost and configured to connect to the shared `postgres` container over the external `postgres` Docker network.

## Prerequisites

- Docker and Docker Compose
- The `postgres` stack running (creating the external `postgres` Docker network and PostgreSQL instance)

## Getting Started

1. **Create the `vaultwarden` database and user** in your running `postgres` container (once):
   ```bash
   docker exec -it postgres psql -U postgres -c "CREATE USER vault_user WITH ENCRYPTED PASSWORD 'CHANGE_THIS_TO_YOUR_POSTGRES_PASSWORD';"
   docker exec -it postgres psql -U postgres -c "CREATE DATABASE vaultwarden OWNER vault_user;"
   ```

2. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `vault/.env` with a generated `ADMIN_TOKEN`, then set `DOMAIN` and your PostgreSQL password in `DATABASE_URL`:
   ```bash
   bash scripts/setup.sh vault
   ```

3. **Start the service:**
   ```bash
   cd vault
   docker compose up -d
   ```

4. **Open Vaultwarden:**
   Visit `http://127.0.0.1:8083` (or your configured `DOMAIN` reverse proxy URL) in your browser. After creating your account, set `SIGNUPS_ALLOWED=false` in `.env` and recreate the container.

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `vaultwarden` | `vault` | Vaultwarden password manager server & web vault (`127.0.0.1:8083`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `VAULT_PORT` | `8083` | Host port mapped to container port `80` on `127.0.0.1`. |
| `DOMAIN` | `https://vault.example.com` | Public URL of the vault (used for links, emails, and WebAuthn). |
| `DATABASE_URL` | `postgresql://vault_user:CHANGE_THIS_TO_YOUR_POSTGRES_PASSWORD@postgres:5432/vaultwarden` | PostgreSQL connection string pointing to the `postgres` container. |
| `SIGNUPS_ALLOWED` | `true` | Allows new user registration; set to `false` after creating your account. |
| `ADMIN_TOKEN` | Generated (`base64\|32`) | Token for accessing the `/admin` panel (leave empty to disable). |
| `TZ` | `Asia/Kolkata` | Container timezone. |

### `compose.yml` Parameters

- **`vaultwarden` service (`vault`)**:
  - `image`: Uses `vaultwarden/server:latest-alpine` with `restart: unless-stopped`.
  - `ports`: Publishes `127.0.0.1:${VAULT_PORT:-8083}:80` so Vaultwarden is only accessible on localhost.
  - `env_file`: Loads `.env`.
  - `volumes`: Mounts `./data:/data` for persistent vault attachments, RSA keys, and icons.
  - `extra_hosts`: Maps `host.docker.internal` to `host-gateway`.
  - `networks`: Joins `default` and the external `postgres` network.

## Useful Commands

```bash
# View logs
docker compose logs -f vaultwarden

# Stop services
docker compose down
```
