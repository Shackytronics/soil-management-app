"""Helpers for consistent HTTP responses (used by utility endpoints)."""
from __future__ import annotations

from typing import Any

from rest_framework.response import Response


def success(data: Any, status_code: int = 200) -> Response:
    return Response(data, status=status_code)


def error(message: str, status_code: int = 400, code: str | None = None) -> Response:
    body: dict[str, Any] = {"error": message}
    if code:
        body["code"] = code
    return Response(body, status=status_code)
