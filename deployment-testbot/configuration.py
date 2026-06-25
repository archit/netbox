import os

# Required settings - all injected via environment variables
ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', '*').split(',')

DATABASE = {
    'ENGINE': 'django.db.backends.postgresql',
    'NAME': os.environ.get('DB_NAME', 'netbox'),
    'USER': os.environ.get('DB_USER', 'netbox'),
    'PASSWORD': os.environ.get('DB_PASSWORD', 'netbox'),
    'HOST': os.environ.get('DB_HOST', 'postgres'),
    'PORT': os.environ.get('DB_PORT', '5432'),
    'CONN_MAX_AGE': 300,
}

REDIS = {
    'tasks': {
        'HOST': os.environ.get('REDIS_HOST', 'redis'),
        'PORT': int(os.environ.get('REDIS_PORT', 6379)),
        'PASSWORD': os.environ.get('REDIS_PASSWORD', ''),
        'DATABASE': int(os.environ.get('REDIS_DATABASE', 0)),
        'SSL': False,
    },
    'caching': {
        'HOST': os.environ.get('REDIS_HOST', 'redis'),
        'PORT': int(os.environ.get('REDIS_PORT', 6379)),
        'PASSWORD': os.environ.get('REDIS_PASSWORD', ''),
        'DATABASE': int(os.environ.get('REDIS_CACHE_DATABASE', 1)),
        'SSL': False,
    }
}

SECRET_KEY = os.environ.get('SECRET_KEY', 'testbot-insecure-secret-key-not-for-prod-at-least-50-chars-long!')

# API token peppers — leave empty to use v1 tokens only (simpler for testbot)
# v2 tokens require peppers; we'll create v1 tokens via the provision endpoint
API_TOKEN_PEPPERS = {}

# Optional settings
DEBUG = os.environ.get('DEBUG', 'False').lower() in ('true', '1', 'yes')
TIME_ZONE = os.environ.get('TIME_ZONE', 'UTC')
LOGIN_REQUIRED = False
CORS_ORIGIN_ALLOW_ALL = True
EXEMPT_VIEW_PERMISSIONS = ['*']
CENSUS_REPORTING_ENABLED = False
