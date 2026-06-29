"""Tests for the unauthenticated status and version endpoints (no database)."""
from __future__ import annotations

from django.test import SimpleTestCase
from rest_framework.test import APIRequestFactory

from common.constants import API_VERSION, RULESET_VERSION
from common.status import StatusView, VersionView


class StatusEndpointTests(SimpleTestCase):
    def setUp(self) -> None:
        self.factory = APIRequestFactory()

    def test_status_ok(self) -> None:
        request = self.factory.get("/api/v1/status/")
        response = StatusView.as_view()(request)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data["status"], "ok")
        self.assertEqual(response.data["apiVersion"], API_VERSION)
        self.assertIn("firebase", response.data)

    def test_version_ok(self) -> None:
        request = self.factory.get("/api/v1/version/")
        response = VersionView.as_view()(request)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data["apiVersion"], API_VERSION)
        self.assertEqual(response.data["rulesetVersion"], RULESET_VERSION)
