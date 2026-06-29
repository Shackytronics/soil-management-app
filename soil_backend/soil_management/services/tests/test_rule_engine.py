"""Unit tests for the rule engine (pure Python, no database, no Django setup)."""
from __future__ import annotations

import unittest

from common.constants import (
    HEALTH_GOOD,
    HEALTH_POOR,
    STATUS_CRITICAL,
    STATUS_HEALTHY,
    Category,
    Priority,
)
from soil_management.schema import SoilReading
from soil_management.services.rule_engine import (
    ParamStatus,
    RuleEngine,
    classify,
)
from soil_management.services.thresholds import THRESHOLDS


def _optimal_reading() -> SoilReading:
    return SoilReading(
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


def _poor_reading() -> SoilReading:
    return SoilReading(
        plot_id="P1",
        measurement_id="M2",
        nitrogen=2,
        phosphorus=1,
        potassium=10,
        ph=4.5,
        moisture=10,
        temperature=5,
        ec=3.0,
    )


class ClassifyTests(unittest.TestCase):
    def test_optimal(self) -> None:
        self.assertEqual(classify(20, THRESHOLDS["nitrogen"]), ParamStatus.OPTIMAL)

    def test_low(self) -> None:
        self.assertEqual(classify(2, THRESHOLDS["nitrogen"]), ParamStatus.LOW)

    def test_high(self) -> None:
        self.assertEqual(classify(500, THRESHOLDS["potassium"]), ParamStatus.HIGH)

    def test_near_low(self) -> None:
        # nitrogen low=10, near band starts at 8
        self.assertEqual(classify(9, THRESHOLDS["nitrogen"]), ParamStatus.NEAR_LOW)


class RuleEngineTests(unittest.TestCase):
    def setUp(self) -> None:
        self.engine = RuleEngine()

    def test_optimal_reading_is_good_and_healthy(self) -> None:
        result = self.engine.run(_optimal_reading())
        self.assertEqual(result.soil_health_score, 100)
        self.assertEqual(result.soil_health, HEALTH_GOOD)
        self.assertEqual(result.overall_status, STATUS_HEALTHY)
        self.assertEqual(len(result.recommendations), 1)
        self.assertEqual(
            result.recommendations[0].category, Category.BEST_PRACTICES
        )

    def test_poor_reading_is_poor_and_critical(self) -> None:
        result = self.engine.run(_poor_reading())
        self.assertEqual(result.soil_health_score, 20)
        self.assertEqual(result.soil_health, HEALTH_POOR)
        self.assertEqual(result.overall_status, STATUS_CRITICAL)
        self.assertGreater(len(result.recommendations), 1)

    def test_poor_reading_triggers_crop_rotation(self) -> None:
        result = self.engine.run(_poor_reading())
        categories = {r.category for r in result.recommendations}
        self.assertIn(Category.CROP_ROTATION, categories)

    def test_acidic_soil_is_high_priority(self) -> None:
        result = self.engine.run(_poor_reading())
        ph_recs = [r for r in result.recommendations if r.category == Category.SOIL_PH]
        self.assertTrue(ph_recs)
        self.assertEqual(ph_recs[0].priority, Priority.HIGH)

    def test_all_recommendation_icons_are_strings(self) -> None:
        result = self.engine.run(_poor_reading())
        for rec in result.recommendations:
            self.assertIsInstance(rec.icon, str)
            self.assertTrue(rec.icon)


if __name__ == "__main__":
    unittest.main()
