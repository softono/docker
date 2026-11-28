# Nod

Docker Compose setup for [n8n-io/nod](https://github.com/n8n-io/nod), configured to use the shared `postgres` container instead of a separate PostgreSQL service.

## Prerequisites

- Docker and Docker Compose (Linux)
- The `postgres` stack running (creating the external `postgres` Docker network and PostgreSQL instance)

## Getting Started

1. **Create the `nod` database** in your running `postgres` container (once):
   ```bash
   docker exec -it postgres psql -U postgres -c "CREATE DATABASE nod;"
   ```

2. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `nod/.env`, then set your PostgreSQL password in `DATABASE_URL`:
   ```bash
   scripts/setup.sh nod
   ```
   or copy the `.env.example` file to `.env` and edit it manually.

3. **Build and start the services:**
   ```bash
   cd nod
   docker compose up -d --build
   ```

4. **Open Nod:**
   Visit `http://127.0.0.1:4310` in your browser.

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `nod` | `nod` | Nod server & web UI (`127.0.0.1:4310`) |
| `browser` | `nod-browser` | Sandboxed Chromium browser worker |
| `workspace` | `nod-workspace` | Sandboxed agent workspace |
| `workspace-network` | — | Network namespace & firewall for `workspace` |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `PORT` | `4310` | Host port mapped to the `nod` container (`127.0.0.1:${PORT}:4310`) and the port the Nod server listens on inside the container. |
| `NOD_HOST` | `0.0.0.0` | Bind address for the Nod server inside the container (`0.0.0.0` is required so Docker port forwarding can reach it). |
| `NOD_BROWSER_CPUS` | `6` | CPU limit assigned to the `browser` (`nod-browser`) container. |
| `NOD_WORKSPACE_CPUS` | `4` | CPU limit assigned to the `workspace` (`nod-workspace`) container. |
| `DATABASE_URL` | `postgresql://postgres:CHANGE_THIS_TO_YOUR_POSTGRES_PASSWORD@postgres:5432/nod` | PostgreSQL connection string pointing to the external `postgres` container over the `postgres` Docker network. |

### `compose.yml` Parameters

- **Project (`name: nod`)**: Sets the Docker Compose project name to `nod`.
- **`nod` service**:
  - `build`: Builds from the local `./Dockerfile` (clones `n8n-io/nod`, installs dependencies with `pnpm`, builds the UI with `vite`, and includes `docker.io` CLI).
  - `ports`: Publishes `127.0.0.1:${PORT:-4310}:4310` so the UI/API is only accessible on localhost.
  - `env_file` & `environment`: Loads `.env` and sets `NOD_HOST=0.0.0.0`, `PORT`, `WORKSPACE_CONTAINER=nod-workspace`, and `BROWSER_CONTAINER=nod-browser`.
  - `volumes`: Mounts `./data:/app/.local` for persistent app data and `/var/run/docker.sock:/var/run/docker.sock` so `nod` can manage/exec into `nod-browser` and `nod-workspace`.
  - `depends_on`: Waits for `browser` (`service_healthy`) and `workspace` (`service_started`).
  - `networks`: Joins both `default` (`nod`) and `postgres`.
- **`browser` service (`nod-browser`)**:
  - `build`: Builds `Dockerfile.browser` directly from `https://github.com/n8n-io/nod.git#main`.
  - Security & limits: Drops all Linux capabilities (`cap_drop: [ALL]`), enables `no-new-privileges:true`, mounts root filesystem `read_only: true` with writable `tmpfs` mounts (`/tmp`, `/home/node`), sets `init: true`, `pids_limit: 4096`, `mem_limit: 8g`, `shm_size: 1g`, and `cpus: ${NOD_BROWSER_CPUS:-6}`.
  - `volumes`: Uses named volume `browser-data:/data` (holds `/data/control.sock`).
  - `healthcheck`: Verifies `/data/control.sock` is accepting connections.
- **`workspace` service (`nod-workspace`)**:
  - `build` & `image`: Builds `Dockerfile.workspace` from `https://github.com/n8n-io/nod.git#main` as `nod-local-workspace`.
  - `volumes`: Mounts `./data/workspaces:/workspace` for agent workspace files and `workspace-tools:/home/node` for installed tools.
  - `network_mode: service:workspace-network`: Shares the network stack of `workspace-network` (waits for `workspace-network` to be healthy).
  - Security & limits: `cap_drop: [ALL]`, `no-new-privileges:true`, `init: true`, `pids_limit: 4096`, `mem_limit: 8g`, `cpus: ${NOD_WORKSPACE_CPUS:-4}`.
- **`workspace-network` service**:
  - Uses `nod-local-workspace` (`pull_policy: never`) with `cap_add: [NET_ADMIN]` and `dns: [1.1.1.1, 8.8.8.8]` to run `/usr/local/bin/nod-workspace-network` (sets up firewall/network isolation for `workspace`).
  - `healthcheck`: Checks for `/tmp/network-ready`.
- **`volumes` & `networks`**:
  - `workspace-tools` and `browser-data` are Docker-managed named volumes.
  - `networks.default.name: nod` names the stack's default bridge network `nod`.
  - `networks.postgres.external: true` connects `nod`, `browser`, and `workspace-network` to your existing `postgres` Docker network.

## Useful Commands

```bash
# View logs
docker compose logs -f nod

# Stop services
docker compose down
```
