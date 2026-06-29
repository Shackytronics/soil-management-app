"""
Django settings for the Soil Management backend.

Design constraints (per project architecture):
  * Django is the REST API layer ONLY — it is NOT a database.
  * The project uses exactly two databases elsewhere: Hive (device) and
    Cloud Firestore (cloud). Therefore Django runs WITHOUT a relational
    database: no ORM models, no migrations, no PostgreSQL, no SQLite.
  * Authentication is delegated to Firebase (ID token verification).

Compatible with Python 3.12 and Django 5.x.
"""
from __future__ import annotations

import os
from pathlib import Path

from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent

# Load environment variables from a local .env file if present.
load_dotenv(BASE_DIR / ".env")


def _env_bool(name: str, default: bool = False) -> bool:
    return os.environ.get(name, str(default)).strip().lower() in {"1", "true", "yes", "on"}


# ---------------------------------------------------------------------------
# Core
# ---------------------------------------------------------------------------
SECRET_KEY = os.environ.get(
    "SECRET_KEY",
    "dev-insecure-secret-key-change-me-in-production",
)

DEBUG = _env_bool("DEBUG", True)

ALLOWED_HOSTS = [
    h.strip()
    for h in os.environ.get("ALLOWED_HOSTS", "*").split(",")
    if h.strip()
]

ROOT_URLCONF = "config.urls"
WSGI_APPLICATION = "config.wsgi.application"
ASGI_APPLICATION = "config.asgi.application"

# ---------------------------------------------------------------------------
# Applications
#
# Note: no django.contrib.admin / auth / sessions / contenttypes — those
# require a relational database, which this service intentionally avoids.
# ---------------------------------------------------------------------------
INSTALLED_APPS = [
    "corsheaders",
    "rest_framework",
    "authentication",
    "soil_management",
    "common",
]

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.middleware.common.CommonMiddleware",
]

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {"context_processors": []},
    },
]

# ---------------------------------------------------------------------------
# Database — the "dummy" backend. Django runs WITHOUT a real database
# (no SQLite, no PostgreSQL): there are no models, no migrations, and nothing
# touches the ORM. The dummy connection only satisfies Django's startup
# machinery (e.g. runserver's migration check) and raises if actually used.
# ---------------------------------------------------------------------------
DATABASES: dict[str, dict] = {
    "default": {
        "ENGINE": "django.db.backends.dummy",
    }
}

# ---------------------------------------------------------------------------
# Django REST Framework
# ---------------------------------------------------------------------------
REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "authentication.authentication.FirebaseAuthentication",
    ],
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.AllowAny",
    ],
    "DEFAULT_RENDERER_CLASSES": [
        "rest_framework.renderers.JSONRenderer",
    ],
    "DEFAULT_PARSER_CLASSES": [
        "rest_framework.parsers.JSONParser",
    ],
    # No relational auth backend -> unauthenticated requests carry no user.
    "UNAUTHENTICATED_USER": None,
    "EXCEPTION_HANDLER": "common.exceptions.api_exception_handler",
}

# ---------------------------------------------------------------------------
# CORS — mobile clients do not send an Origin header, but allow configuration
# for browser-based testing tools.
# ---------------------------------------------------------------------------
CORS_ALLOW_ALL_ORIGINS = _env_bool("CORS_ALLOW_ALL_ORIGINS", True)
CORS_ALLOWED_ORIGINS = [
    o.strip()
    for o in os.environ.get("CORS_ALLOWED_ORIGINS", "").split(",")
    if o.strip()
]

# ---------------------------------------------------------------------------
# Firebase / Firestore
# ---------------------------------------------------------------------------
FIREBASE_CREDENTIALS = os.environ.get("FIREBASE_CREDENTIALS", "")
# Optional server-side audit mirroring of generated advisories (default OFF).
FIRESTORE_AUDIT = _env_bool("FIRESTORE_AUDIT", False)

# ---------------------------------------------------------------------------
# Internationalisation
# ---------------------------------------------------------------------------
LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True

# ---------------------------------------------------------------------------
# Static files (only needed if static assets are ever served)
# ---------------------------------------------------------------------------
STATIC_URL = "static/"

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "simple": {"format": "[{levelname}] {name}: {message}", "style": "{"},
    },
    "handlers": {
        "console": {"class": "logging.StreamHandler", "formatter": "simple"},
    },
    "root": {"handlers": ["console"], "level": "INFO"},
}
