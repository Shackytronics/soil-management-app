"""Permission classes for Firebase-authenticated endpoints."""
from __future__ import annotations

from rest_framework.permissions import BasePermission
from rest_framework.request import Request
from rest_framework.views import APIView


class IsFirebaseAuthenticated(BasePermission):
    """Allow access only when a valid Firebase identity is attached."""

    message = "A valid Firebase authentication token is required."

    def has_permission(self, request: Request, view: APIView) -> bool:
        user = getattr(request, "user", None)
        return bool(user is not None and getattr(user, "is_authenticated", False))
