# Redis

Docker Compose setup for [Redis](https://redis.io/) (`redis:latest`), tuned for a 1 GB RAM / 2 CPU core footprint with AOF persistence, password authentication, and its own shared `redis` Docker network.

## Prerequisites

- Docker and Docker Compose

## Getting Started

1. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `redis/.env` with a generated `REDIS_PASSWORD`:
   ```bash
   bash scripts/setup.sh redis
   ```

2. **Start the service:**
   ```bash
   cd redis
   docker compose up -d
   ```

3. **Connect to Redis:**
   - From the host: `127.0.0.1:6379`
   - From other stacks joining the external `redis` network (such as `coolify` and `omniroute`): `redis:6379`

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `redis` | `redis` | Redis server (`:6379`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `REDIS_PASSWORD` | Generated (`alnum\|24`) | Password required by `--requirepass`. |
| `TZ` | `UTC` | Container timezone. |

### `compose.yml` Parameters

- **`redis` service (`redis`)**:
  - `image`: Uses `redis:latest` with `restart: no`.
  - `ports`: Publishes `6379:6379`.
  - `volumes`: Uses named volume `data:/data` for AOF persistence.
  - `mem_limit` / `memswap_limit` / `cpus`: Caps resources at `1g` RAM (no swap) and `2` CPUs.
  - `command`: Starts `redis-server` with `--requirepass ${REDIS_PASSWORD}`, `--appendonly yes`, `--maxmemory 512mb`, `--maxmemory-policy allkeys-lru`, `--io-threads 2`, and `--io-threads-do-reads yes`.
  - `networks`: Creates the `redis` bridge network (`networks.redis.name: redis`) used as an external network by other stacks.

## Useful Commands

```bash
# Open a redis-cli session
docker exec -it redis redis-cli -a "$REDIS_PASSWORD"

# View logs
docker compose logs -f redis

# Stop services
docker compose down
```
