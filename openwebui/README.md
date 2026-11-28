# Open WebUI

Docker Compose setup for [Open WebUI](https://docs.openwebui.com/) (`ghcr.io/open-webui/open-webui`), configured to connect to an OpenAI-compatible API endpoint with Ollama disabled.

## Prerequisites

- Docker and Docker Compose

## Getting Started

1. **Configure environment variables:**
   From the repository root, run `scripts/setup.sh` to create `openwebui/.env` with a generated `WEBUI_SECRET_KEY`, then set `WEBUI_DOCKER_TAG` (e.g. `main`), `WEBUI_URL`, `OPENAI_API_BASE_URL`, and `OPENAI_API_KEY`:
   ```bash
   ./scripts/setup.sh openwebui
   ```
   or
   ```bash
   cp .env.example .env
   ```
   copy the `.env.example` file to `.env` and edit it manually.

2. **Start the service:**
   ```bash
   cd openwebui
   docker compose up -d
   ```

3. **Open Open WebUI:**
   Visit `http://127.0.0.1:8090` (or `http://<server-ip>:8090`) in your browser.

## Services

| Service | Container | Purpose |
| --- | --- | --- |
| `open-webui` | `open-webui` | Open WebUI chat interface (`:8090`) |

## Documentation

### Environment Variables (`.env`)

| Variable | Default | Description |
| --- | --- | --- |
| `WEBUI_NAME` | `AiChat` | Display name shown in the Open WebUI interface. |
| `WEBUI_URL` | `https://aichat.example.com` | Public URL of the Open WebUI instance. |
| `OPEN_WEBUI_PORT` | `8090` | Host port mapped to container port `8080`. |
| `WEBUI_SECRET_KEY` | Generated (`base64\|32`) | Secret key used for session and token signing. |
| `OPENAI_API_BASE_URL` | `https://api.openai.com/v1` | Base URL for the OpenAI-compatible backend API (e.g. 9Router, LiteLLM, or OpenAI). |
| `OPENAI_API_KEY` | `change_me` | API key for the OpenAI-compatible backend. |
| `WEBUI_DOCKER_TAG` | *(must be set in `.env`)* | Image tag for `ghcr.io/open-webui/open-webui` (for example, `main`). |

### `compose.yml` Parameters

- **`open-webui` service (`open-webui`)**:
  - `image`: Uses `ghcr.io/open-webui/open-webui:${WEBUI_DOCKER_TAG}` with `restart: unless-stopped`.
  - `ports`: Publishes `${OPEN_WEBUI_PORT}:8080`.
  - `env_file` & `environment`: Loads `.env`, disables Ollama (`ENABLE_OLLAMA_API=false`), enables OpenAI-compatible API (`ENABLE_OPENAI_API=true`), and enables authentication and user signups (`WEBUI_AUTH=true`, `ENABLE_SIGNUP=true`, `DEFAULT_USER_ROLE=user`).
  - `volumes`: Uses named volume `open-webui-data:/app/backend/data` for persistent users, chats, and settings.
  - `extra_hosts`: Maps `host.docker.internal` to `host-gateway` so the container can reach host-local APIs.

## Useful Commands

```bash
# View logs
docker compose logs -f open-webui

# Stop services
docker compose down
```
