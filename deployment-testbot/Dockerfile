# NetBox from-source Dockerfile for testbot benchmarking
# Mirrors the approach from netbox-community/netbox-docker but self-contained.
# Build context: repo root (one level up from deployment-testbot/)
# Python 3.12 required (see AGENTS.md)

FROM python:3.12-slim

# System packages required by psycopg[c] (libpq-dev) and Pillow (libjpeg, zlib)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    gcc \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/netbox

# Copy requirements and install Python deps first (layer-cache friendly)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the source
COPY . .

# Create configuration.py from env vars at startup via entrypoint
# (we inject a configuration.py that reads env vars)
COPY deployment-testbot/configuration.py /opt/netbox/netbox/netbox/configuration.py

# Create static dir and media dir
RUN mkdir -p /opt/netbox/netbox/static /opt/netbox/netbox/media

COPY deployment-testbot/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
