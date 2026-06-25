#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
echo "Building NetBox from source + starting (slow — pip install + migrations + collectstatic on first boot)..."
docker compose -f docker-compose.yml up -d --build
echo "Waiting for readiness on :8092/api/status/ (up to ~12 min for first-run build + migrate + collectstatic)..."
for i in $(seq 1 240); do
  if curl -sf -m5 -o /dev/null http://localhost:8092/api/status/; then echo "healthy after $((i*3))s"; break; fi
  sleep 3
  [ "$i" = 240 ] && { echo "unhealthy — dumping logs"; docker compose logs --tail 200; exit 1; }
done
echo "Setup complete"
