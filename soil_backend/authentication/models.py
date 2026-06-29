"""
Lightweight request user.

This is intentionally NOT a Django ORM model — the service is DB-less. It only
provides the minimal interface DRF expects on ``request.user``.
"""
from __future__ import annotations

from typing import Any


class FirebaseUser:
    """Represents an authenticated Firebase identity for the request lifecycle."""

    def __init__(
        self,
        uid: str,
        email: str | None = None,
        claims: dict[str, Any] | None = None,
    ) -> None:
        self.uid = uid
        self.email = email
        self.claims = claims or {}

    @property
    def is_authenticated(self) -> bool:
        return True

    @property
    def is_anonymous(self) -> bool:
        return False

    def __str__(self) -> str:
        return self.uid or "FirebaseUser"
