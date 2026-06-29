"""
Firebase Admin SDK integration.

Responsibilities:
  * Initialise the Admin SDK once (tolerant of missing credentials).
  * Verify Firebase ID tokens sent by the Flutter client.
  * Provide an optional Firestore client for server-side audit mirroring.

This module never raises at import time, so the server always boots.
"""
from __future__ import annotations

import logging
import os
from typing import Any

import firebase_admin
from firebase_admin import auth as fb_auth
from firebase_admin import credentials, firestore

logger = logging.getLogger(__name__)

_initialised = False
_init_attempted = False


class FirebaseUnavailable(RuntimeError):
    """Raised when a Firebase operation is requested but the SDK is not ready."""


def init_firebase() -> bool:
    """Initialise the Firebase Admin SDK once. Returns True on success."""
    global _initialised, _init_attempted
    _init_attempted = True

    if _initialised or firebase_admin._apps:  # already initialised
        _initialised = True
        return True

    cred_path = os.environ.get("FIREBASE_CREDENTIALS", "").strip()
    try:
        if cred_path and os.path.exists(cred_path):
            cred = credentials.Certificate(cred_path)
            firebase_admin.initialize_app(cred)
        else:
            # Fall back to Application Default Credentials if available
            # (e.g. GOOGLE_APPLICATION_CREDENTIALS env var on a server).
            firebase_admin.initialize_app()
        _initialised = True
        return True
    except Exception as exc:  # noqa: BLE001 - tolerate any init failure
        logger.warning("Firebase Admin initialisation failed: %s", exc)
        _initialised = False
        return False


def is_available() -> bool:
    """Return True if the Firebase Admin SDK is ready to use."""
    if _initialised:
        return True
    if not _init_attempted:
        return init_firebase()
    return False


def verify_id_token(id_token: str) -> dict[str, Any]:
    """Verify a Firebase ID token and return its decoded claims."""
    if not is_available():
        raise FirebaseUnavailable("Firebase Admin is not configured.")
    return fb_auth.verify_id_token(id_token)


def get_firestore_client() -> Any:
    """Return a Firestore client (used only for optional audit mirroring)."""
    if not is_available():
        raise FirebaseUnavailable("Firebase Admin is not configured.")
    return firestore.client()
