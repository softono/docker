# MongoDB

Docker Compose setup for [MongoDB](https://www.mongodb.com/) (`mongo:4.4`), tuned for a 1 GB RAM / 2 CPU core footprint with authentication enabled and its own `mongodb` Docker network.

## Prerequisites

- Docker and Docker Compose

## Getting Started

1. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `mongodb/.env` with a generated `MONGO_INITDB_ROOT_PASSWORD`:
   ```bash
   ./scripts/setup.sh mongodb
   ```
   or
   ```bash
   cp .env.example .env
   ```
   copy the `.env.example` file to `.env` and edit it manually.

2. **Start the service:**
   ```bash
   cd mongodb
   docker compose up -d
   ```

3. **Connect to MongoDB:**
   - From the host: `127.0.0.1:27017`
   - From other containers on the `mongodb` network: `mongodb:27017`

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `mongodb` | `mongodb` | MongoDB 4.4 database server (`127.0.0.1:27017`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `MONGO_INITDB_ROOT_USERNAME` | `root` | Initial root username created on first boot. |
| `MONGO_INITDB_ROOT_PASSWORD` | Generated (`alnum\|24`) | Password for the root user. |
| `TZ` | `UTC` | Container timezone. |

### `compose.yml` Parameters

- **`mongodb` service (`mongodb`)**:
  - `image`: Uses `mongo:4.4` with `restart: unless-stopped`.
  - `ports`: Publishes `127.0.0.1:27017:27017` so MongoDB is only exposed on localhost.
  - `volumes`: Uses named volumes `mongodb_data:/data/db` and `mongodb_config:/data/configdb`.
  - `mem_limit` / `memswap_limit` / `cpus`: Caps resources at `1g` RAM (no swap) and `2` CPUs.
  - `command`: Enables `--auth`, sets `--wiredTigerCacheSizeGB=0.25`, and logs slow queries with `--slowms=200`.
  - `networks`: Joins the `mongodb` bridge network (`networks.mongodb.name: mongodb`).

## Useful Commands

```bash
# Open a MongoDB shell
docker exec -it mongodb mongo -u root -p

# View logs
docker compose logs -f mongodb

# Stop services
docker compose down
```
