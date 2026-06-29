"""Unit tests for the recommendation service facade."""
from __future__ import annotations

import unittest
from datetime import datetime

from soil_management.schema import AdvisoryResult, SoilReading
from soil_management.services.recommendation_service import generate_advisory


class RecommendationServiceTests(unittest.TestCase):
    def test_returns_advisory_result(self) -> None:
        reading = SoilReading(
            plot_id="P1",
            measurement_id="M1",
            nitrogen=20,
            phosphorus=15,
            potassium=200,
            ph=6.5,
            moisture=55,
            temperature=25,
            ec=0.5,
        )
        result = generate_advisory(reading)
        self.assertIsInstance(result, AdvisoryResult)
        self.assertIsInstance(result.generated_at, datetime)
        self.assertTrue(0 <= result.soil_health_score <= 100)
        self.assertTrue(result.recommendations)


if __name__ == "__main__":
    unittest.main()
