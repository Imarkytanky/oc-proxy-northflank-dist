# Hugging Face Space — oc-proxy (Layer P)
# Thin OpenAI-compatible proxy for the opencode.ai free tier.
# Zero npm dependencies; Node >= 18 native fetch. Listens on 0.0.0.0:7860.
FROM node:20-slim

WORKDIR /app
COPY package.json ./
COPY api ./api
COPY lib ./lib
COPY public ./public
COPY scripts ./scripts
COPY server.js ./

ENV PORT=7860 \
    HOST=0.0.0.0 \
    NODE_ENV=production \
    OC_PROXY_UPSTREAM_DIR=/app

EXPOSE 7860

# No HEALTHCHECK needed — HF probes app_port itself.
CMD ["node", "server.js"]
