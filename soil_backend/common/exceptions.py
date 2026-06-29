"""
Custom DRF exception handling.

Normalises error payloads to ``{"error": "..."}`` so the Flutter client gets a
predictable shape regardless of the failure (validation, auth, server).
"""
from __future__ import annotations

from typing import Any

from rest_framework.views import exception_handler as drf_exception_handler


def api_exception_handler(exc: Exception, context: dict[str, Any]):
    response = drf_exception_handler(exc, context)
    if response is None:
        return None

    data = response.data
    if isinstance(data, dict) and "detail" in data:
        response.data = {"error": str(data["detail"])}
    elif isinstance(data, dict):
        # Field validation errors -> keep them under a single "errors" key.
        response.data = {"error": "Invalid request.", "errors": data}
    elif isinstance(data, list):
        response.data = {"error": "; ".join(str(item) for item in data)}

    return response
