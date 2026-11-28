# PostgreSQL

Docker Compose setup for [PostgreSQL](https://www.postgresql.org/) (`postgres:18.6`), tuned for a 1 GB RAM / 2 CPU core footprint with `pg_stat_statements` enabled and its own shared `postgres` Docker network.

## Prerequisites

- Docker and Docker Compose

## Getting Started

1. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `postgres/.env` with a generated `POSTGRES_PASSWORD`:
   ```bash
   ./scripts/setup.sh postgres
   ```
   or
   ```bash
   cp .env.example .env
   ```
   copy the `.env.example` file to `.env` and edit it manually.

2. **Start the service:**
   ```bash
   cd postgres
   docker compose up -d
   ```

3. **Connect to PostgreSQL:**
   - From the host: `127.0.0.1:5432`
   - From other stacks joining the external `postgres` network (such as `coolify`, `lightllm`, `n8n`, `nod`, `vault`): `postgres:5432`

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `postgres` | `postgres` | PostgreSQL 18.6 database server (`127.0.0.1:5432`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `POSTGRES_USER` | `postgres` | Superuser role name. |
| `POSTGRES_PASSWORD` | Generated (`alnum\|24`) | Superuser password. |
| `TZ` | `UTC` | Container and PostgreSQL session timezone (`TZ` and `PGTZ`). |

### `compose.yml` Parameters

- **`postgres` service (`postgres`)**:
  - `image`: Uses `postgres:18.6` with `restart: unless-stopped` and `stop_grace_period: 1m`.
  - `ports`: Publishes `127.0.0.1:5432:5432` so PostgreSQL is only exposed on localhost.
  - `volumes`: Uses named volume `postgres_data:/var/lib/postgresql`.
  - `shm_size` / `mem_limit` / `memswap_limit` / `cpus`: Allocates `256mb` shared memory and caps resources at `1g` RAM (no swap) and `2` CPUs.
  - `command`: Configures `max_connections=50`, `shared_buffers=256MB`, `effective_cache_size=512MB`, `work_mem=4MB`, `wal_compression=on`, SSD planner settings (`random_page_cost=1.1`), 2-core parallelism, aggressive autovacuum, and `pg_stat_statements` query monitoring.
  - `networks`: Creates the `postgres` bridge network (`networks.postgres.name: postgres`) used as an external network by other stacks.

## Useful Commands

```bash
# Open a psql shell
docker exec -it postgres psql -U postgres

# View logs
docker compose logs -f postgres

# Stop services
docker compose down
```
