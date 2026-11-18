---
title: oc-proxy
emoji: 🛡️
colorFrom: gray
colorTo: blue
sdk: docker
app_port: 7860
pinned: false
license: mit
short_description: OpenAI-compatible proxy for the opencode.ai free tier
---

# oc-proxy — OpenAI-compatible proxy for the opencode.ai free tier

Deployed here as **Layer P** of the opencode-unlimited-models stack, packaged
for Hugging Face Spaces instead of Vercel (no `maxDuration` hard-kill, so long
agentic runs survive; raise `SOFT_DEADLINE_MS` / `ABSOLUTE_DEADLINE_MS`).

Upstream: [MarkDev11/oc-proxy](https://github.com/MarkDev11/oc-proxy)
(commit 2a41370e4ee1). Vercel-free packaging by the
opencode-unlimited-models stack.

## Endpoints (same contract as upstream)

| Route | Method | Purpose |
|---|---|---|
| `/v1/models` | GET | live `*-free` model list (5 min cache) |
| `/v1/chat/completions` | POST | OpenAI-shaped chat (stream + non-stream) |
| `/api/health` | GET | health check |
| `/` | GET | live monitor dashboard |
| `/api/stats` | GET | stats JSON snapshot |

## Quick test

```bash
BASE=https://<YOUR-USER>-oc-proxy.hf.space
curl $BASE/api/health
curl $BASE/v1/models | head -c 400
curl $BASE/v1/chat/completions \
  -H "Authorization: Bearer $GATEWAY_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"oc/muse-spark-1.3-contributor-free","messages":[{"role":"user","content":"reply OK"}]}'
```

## Configuration (Space settings -> Variables and secrets)

| Variable | Required | Notes |
|---|---|---|
| `GATEWAY_API_KEY` | strongly recommended | comma-separated keys; open access if unset — **do not expose publicly without it** |
| `SOFT_DEADLINE_MS` | no | default 50000; on HF raise (e.g. 300000) |
| `ABSOLUTE_DEADLINE_MS` | no | default 55000; on HF raise (e.g. 330000) |
| `PROXY_FALLBACK` | no | `1` enables 429-fallback via pooled proxies |
| `PROXY_POOL_URL` | no | pool JSON (upstream pool branch via jsDelivr) |
| `UPSTREAM_BASE_URL` | no | default `https://opencode.ai` |

## Caveats (inherited from upstream)

- Upstream free tier rate-limits aggressively (`429 FreeUsageLimitError`) — normal; retry with backoff.
- The decoy cloak spoofs the `within OpenCode` check. Upstream may block it at any time.
- Free Spaces sleep after 48h inactivity; in-memory stats reset on restart.
- Upstream oc-proxy has no LICENSE file — see UPSTREAM_PROVENANCE for the exact commit deployed.
