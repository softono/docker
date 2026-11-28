# LiteLLM

Docker Compose setup for [LiteLLM Proxy](https://docs.litellm.ai/) (`ghcr.io/berriai/litellm:main-stable`), configured to use the shared `postgres` container and a local `config.yaml`.

## Prerequisites

- Docker and Docker Compose
- The `postgres` stack running (creating the external `postgres` Docker network and PostgreSQL instance)

## Getting Started

1. **Create the `litellm` database and user** in your running `postgres` container (once):
   ```bash
   docker exec -it postgres psql -U postgres -c "CREATE USER litellm_user WITH ENCRYPTED PASSWORD 'CHANGE_THIS_PASSWORD';"
   docker exec -it postgres psql -U postgres -c "CREATE DATABASE litellm OWNER litellm_user;"
   ```

2. **Configure environment variables and `config.yaml`:**
   From the repository root, run `scripts/setup.sh` to create `lightllm/.env` with generated `LITELLM_MASTER_KEY` and `UI_PASSWORD`, then update `DATABASE_URL` and `OPENAI_API_KEY` in `lightllm/.env` as well as `lightllm/config.yaml`:
   ```bash
   ./ lightllm
   ```

3. **Start the service:**
   ```bash
   cd lightllm
   docker compose up -d
   ```

4. **Open LiteLLM:**
   Visit `http://127.0.0.1:4000` (or `/ui` for the Admin UI) in your browser.

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `litellm` | — (Compose-generated) | LiteLLM AI proxy & Admin UI (`127.0.0.1:4000`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `LITELLM_MASTER_KEY` | Generated (`alnum\|32`) | Master key for authenticating LiteLLM proxy API and admin requests. |
| `UI_USERNAME` | `admin` | Username for the LiteLLM Admin UI. |
| `UI_PASSWORD` | Generated (`alnum\|32`) | Password for the LiteLLM Admin UI. |
| `DATABASE_URL` | `postgresql://litellm_user:...@postgres:5432/litellm` | PostgreSQL connection string pointing to the `postgres` container. |
| `OPENAI_API_KEY` | *(empty)* | OpenAI API key (if routing to OpenAI models). |
| `STORE_MODEL_IN_DB` | `True` | Stores model configurations in PostgreSQL. |
| `ENABLE_SPEND_LOGS` | `True` | Enables spend and usage logging. |
| `ENABLE_PROMETHEUS_METRICS` | `True` | Enables Prometheus metrics endpoint. |
| `LITELLM_LOG` | `INFO` | Log verbosity level. |
| `JSON_LOGS` | `True` | Outputs structured JSON logs. |
| `REQUEST_TIMEOUT` | `600` | Request timeout in seconds. |
| `MAX_RETRIES` | `3` | Maximum retry attempts for failed upstream requests. |
| `ROUTER_STRATEGY` | `fallback` | Routing strategy used by LiteLLM. |
| `DISABLE_ADMIN_UI` | `False` | Keeps the Admin UI enabled when `False`. |

### `compose.yml` Parameters

- **`litellm` service**:
  - `image`: Uses `ghcr.io/berriai/litellm:main-stable`.
  - `ports`: Publishes `127.0.0.1:4000:4000` so the proxy/UI is only accessible on localhost.
  - `env_file`: Loads `.env`.
  - `volumes`: Mounts `./config.yaml:/app/config.yaml:ro` as read-only configuration.
  - `command`: Runs `--config=/app/config.yaml --port=4000`.
  - `networks`: Joins `default` and the external `postgres` network.

## Useful Commands

```bash
# View logs
docker compose logs -f litellm

# Stop services
docker compose down
```
