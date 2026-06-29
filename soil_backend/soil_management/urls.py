"""
Soil-management URL routing.

Mounted under /api/v1/ by the root URLconf, giving:
    POST /api/v1/soil-management/
"""
from __future__ import annotations

from django.urls import path

from .views import SoilManagementView

urlpatterns = [
    path("soil-management/", SoilManagementView.as_view(), name="soil-management"),
]
