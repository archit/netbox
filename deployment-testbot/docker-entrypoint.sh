#!/usr/bin/env bash
set -euo pipefail

cd /opt/netbox

echo "==> Waiting for PostgreSQL..."
until python -c "import psycopg; psycopg.connect(host='${DB_HOST:-postgres}', dbname='${DB_NAME:-netbox}', user='${DB_USER:-netbox}', password='${DB_PASSWORD:-netbox}')" 2>/dev/null; do
  echo "   postgres not ready yet, waiting 2s..."
  sleep 2
done
echo "==> PostgreSQL is ready."

echo "==> Running migrations..."
python netbox/manage.py migrate --no-input

echo "==> Collecting static files..."
python netbox/manage.py collectstatic --no-input

echo "==> Creating superuser (if not exists)..."
SUPERUSER_NAME="${SUPERUSER_NAME:-admin}"
SUPERUSER_EMAIL="${SUPERUSER_EMAIL:-admin@example.com}"
SUPERUSER_PASSWORD="${SUPERUSER_PASSWORD:-Password123!}"
python netbox/manage.py shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='${SUPERUSER_NAME}').exists():
    User.objects.create_superuser('${SUPERUSER_NAME}', '${SUPERUSER_EMAIL}', '${SUPERUSER_PASSWORD}')
    print('Superuser created.')
else:
    print('Superuser already exists.')
"

echo "==> Starting gunicorn on 0.0.0.0:8080..."
exec gunicorn \
  --bind 0.0.0.0:8080 \
  --workers "${GUNICORN_WORKERS:-4}" \
  --threads "${GUNICORN_THREADS:-2}" \
  --timeout 120 \
  --access-logfile - \
  --chdir netbox \
  netbox.wsgi
