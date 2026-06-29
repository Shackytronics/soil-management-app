"""
Backend health and version endpoints.

    GET /api/v1/status/   -> liveness + dependency availability
    GET /api/v1/version/  -> API and ruleset versions

Both are unauthenticated so monitoring tools and the Flutter connectivity
check can reach them without a Firebase token.
"""
from __future__ import annotations

from datetime import datetime, timezone

from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from authentication.firebase import is_available as firebase_available

from .constants import API_VERSION, RULESET_VERSION


class StatusView(APIView):
    authentication_classes: list = []
    permission_classes: list = []

    def get(self, request: Request) -> Response:
        return Response(
            {
                "status": "ok",
                "service": "soil-management-api",
                "apiVersion": API_VERSION,
                "rulesetVersion": RULESET_VERSION,
                "firebase": firebase_available(),
                "time": datetime.now(timezone.utc).isoformat(),
            }
        )


class VersionView(APIView):
    authentication_classes: list = []
    permission_classes: list = []

    def get(self, request: Request) -> Response:
        return Response(
            {
                "apiVersion": API_VERSION,
                "rulesetVersion": RULESET_VERSION,
            }
        )
