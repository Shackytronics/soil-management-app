"""Tests for the Firebase DRF authentication backend (no database)."""
from __future__ import annotations

from django.test import SimpleTestCase
from rest_framework.exceptions import AuthenticationFailed
from rest_framework.test import APIRequestFactory

from authentication.authentication import FirebaseAuthentication


class FirebaseAuthenticationTests(SimpleTestCase):
    def setUp(self) -> None:
        self.factory = APIRequestFactory()
        self.auth = FirebaseAuthentication()

    def test_no_header_returns_none(self) -> None:
        request = self.factory.get("/api/v1/soil-management/")
        self.assertIsNone(self.auth.authenticate(request))

    def test_malformed_header_raises(self) -> None:
        request = self.factory.get(
            "/api/v1/soil-management/", HTTP_AUTHORIZATION="Token abc"
        )
        with self.assertRaises(AuthenticationFailed):
            self.auth.authenticate(request)

    def test_authenticate_header_is_bearer(self) -> None:
        request = self.factory.get("/api/v1/soil-management/")
        self.assertIn("Bearer", self.auth.authenticate_header(request))
