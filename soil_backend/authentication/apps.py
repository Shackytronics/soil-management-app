"""App configuration for the authentication feature module."""
from __future__ import annotations

import logging

from django.apps import AppConfig

logger = logging.getLogger(__name__)


class AuthenticationConfig(AppConfig):
    name = "authentication"
    verbose_name = "Firebase Authentication"

    def ready(self) -> None:
        # Attempt to initialise Firebase Admin at startup. Failure is tolerated
        # so the server still boots (status/version endpoints remain available);
        # protected endpoints will then return 401 until credentials are set.
        from .firebase import init_firebase

        if init_firebase():
            logger.info("Firebase Admin initialised at startup.")
        else:
            logger.warning(
                "Firebase Admin NOT initialised. Set FIREBASE_CREDENTIALS to a "
                "valid service-account JSON to enable protected endpoints."
            )
