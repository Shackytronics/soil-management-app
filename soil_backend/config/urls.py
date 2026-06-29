"""
Root URL configuration.

All endpoints are versioned under /api/v1/:
    GET  /api/v1/status/
    GET  /api/v1/version/
    POST /api/v1/soil-management/
"""
from __future__ import annotations

from django.urls import include, path

from common.status import StatusView, VersionView

urlpatterns = [
    path("api/v1/status/", StatusView.as_view(), name="status"),
    path("api/v1/version/", VersionView.as_view(), name="version"),
    path("api/v1/", include("soil_management.urls")),
]
