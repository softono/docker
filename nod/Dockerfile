FROM node:24.21.0-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git docker.io \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone --depth 1 https://github.com/n8n-io/nod.git . \
    && corepack enable \
    && pnpm install --frozen-lockfile \
    && pnpm exec vite build \
    && pnpm store prune

ENV NODE_ENV=production
ENV NOD_HOST=0.0.0.0
ENV PORT=4310

EXPOSE 4310

CMD ["pnpm", "exec", "tsx", "src/server/index.ts"]
