# MariaDB

Docker Compose setup for [MariaDB](https://mariadb.org/) (`mariadb:12.3`), tuned for a 1 GB RAM / 2 CPU core footprint with its own `mariadb` Docker network.

## Prerequisites

- Docker and Docker Compose

## Getting Started

1. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `mariadb/.env` with a generated `MARIADB_ROOT_PASSWORD`:
   ```bash
   bash scripts/setup.sh mariadb
   ```

2. **Start the service:**
   ```bash
   cd mariadb
   docker compose up -d
   ```

3. **Connect to MariaDB:**
   - From the host: `127.0.0.1:3306`
   - From other containers on the `mariadb` network: `mariadb:3306`

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `mariadb` | `mariadb` | MariaDB 12.3 database server (`127.0.0.1:3306`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `MARIADB_ROOT_PASSWORD` | Generated (`alnum\|24`) | Password for the `root` database user. |
| `TZ` | `UTC` | Container timezone. |

### `compose.yml` Parameters

- **`mariadb` service (`mariadb`)**:
  - `image`: Uses `mariadb:12.3` with `restart: unless-stopped`.
  - `ports`: Publishes `127.0.0.1:3306:3306` so MariaDB is only exposed on localhost.
  - `volumes`: Uses named volume `mariadb_data:/var/lib/mysql` for persistent database storage.
  - `mem_limit` / `memswap_limit` / `cpus`: Caps resources at `1g` RAM (no swap) and `2` CPUs.
  - `command`: Configures `utf8mb4` / `utf8mb4_unicode_ci`, UTC default timezone, and 1 GB tuning (`--innodb-buffer-pool-size=256M`, `--innodb-log-file-size=64M`, `--max-connections=40`, `--performance-schema=OFF`, `--innodb-flush-method=O_DIRECT`, `--skip-log-bin`).
  - `networks`: Joins the `mariadb` bridge network (`networks.mariadb.name: mariadb`).

## Useful Commands

```bash
# Open a MariaDB shell
docker exec -it mariadb mariadb -u root -p

# View logs
docker compose logs -f mariadb

# Stop services
docker compose down
```
