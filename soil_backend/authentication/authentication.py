"""DRF authentication backend that verifies Firebase ID tokens."""
from __future__ import annotations

from typing import Any

from rest_framework.authentication import BaseAuthentication
from rest_framework.exceptions import AuthenticationFailed
from rest_framework.request import Request

from .firebase import FirebaseUnavailable, verify_id_token
from .models import FirebaseUser


class FirebaseAuthentication(BaseAuthentication):
    """
    Expects: ``Authorization: Bearer <firebase_id_token>``.

    Returns ``None`` when no header is present (so AllowAny endpoints work),
    and raises ``AuthenticationFailed`` for malformed/invalid tokens.
    """

    keyword = "Bearer"

    def authenticate(self, request: Request) -> tuple[FirebaseUser, dict[str, Any]] | None:
        header = request.META.get("HTTP_AUTHORIZATION", "")
        if not header:
            return None

        parts = header.split()
        if len(parts) != 2 or parts[0].lower() != self.keyword.lower():
            raise AuthenticationFailed("Invalid Authorization header format.")

        token = parts[1]
        try:
            decoded = verify_id_token(token)
        except FirebaseUnavailable:
            raise AuthenticationFailed("Authentication service is unavailable.")
        except Exception:  # noqa: BLE001 - any verification error -> 401
            raise AuthenticationFailed("Invalid or expired authentication token.")

        user = FirebaseUser(
            uid=decoded.get("uid", ""),
            email=decoded.get("email"),
            claims=decoded,
        )
        return (user, decoded)

    def authenticate_header(self, request: Request) -> str:
        # Ensures DRF returns 401 (not 403) for unauthenticated protected calls.
        return 'Bearer realm="api"'
