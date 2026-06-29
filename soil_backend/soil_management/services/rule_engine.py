"""
Rule-Based Soil Management Engine.

A deterministic engine (NO AI / ML). Each agronomic concern is expressed as a
small, self-contained ``Rule`` object instead of nested if-statements. The
engine:

  1. classifies every parameter against the central THRESHOLDS,
  2. computes a 0-100 soil-health score,
  3. runs each rule to collect structured recommendations,
  4. derives the health label and overall status.

All numeric thresholds/weights live in ``thresholds.py`` — never here.
"""
from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import dataclass
from datetime import datetime, timezone
from enum import StrEnum

from common.constants import (
    HEALTH_GOOD,
    HEALTH_GOOD_MIN,
    HEALTH_MODERATE,
    HEALTH_MODERATE_MIN,
    HEALTH_POOR,
    STATUS_CRITICAL,
    STATUS_HEALTHY,
    STATUS_NEEDS_IMPROVEMENT,
    Category,
    Priority,
)

from ..schema import AdvisoryResult, Recommendation, SoilReading
from .thresholds import (
    CATEGORY_ICONS,
    NEAR_HIGH_FACTOR,
    NEAR_LOW_FACTOR,
    OFF_SCORE,
    OPTIMAL_SCORE,
    NEAR_SCORE,
    THRESHOLDS,
    ParameterThreshold,
)


class ParamStatus(StrEnum):
    """Classification of a single parameter against its optimal range."""

    OPTIMAL = "optimal"
    NEAR_LOW = "near_low"
    NEAR_HIGH = "near_high"
    LOW = "low"
    HIGH = "high"


_STATUS_SCORE: dict[ParamStatus, int] = {
    ParamStatus.OPTIMAL: OPTIMAL_SCORE,
    ParamStatus.NEAR_LOW: NEAR_SCORE,
    ParamStatus.NEAR_HIGH: NEAR_SCORE,
    ParamStatus.LOW: OFF_SCORE,
    ParamStatus.HIGH: OFF_SCORE,
}


def classify(value: float, threshold: ParameterThreshold) -> ParamStatus:
    """Classify a value against its optimal range and near-bands."""
    if threshold.low <= value <= threshold.high:
        return ParamStatus.OPTIMAL
    if value < threshold.low:
        if value >= threshold.low * NEAR_LOW_FACTOR:
            return ParamStatus.NEAR_LOW
        return ParamStatus.LOW
    # value > threshold.high
    if value <= threshold.high * NEAR_HIGH_FACTOR:
        return ParamStatus.NEAR_HIGH
    return ParamStatus.HIGH


@dataclass
class EvaluationContext:
    """Bundles a reading with its per-parameter classifications."""

    reading: SoilReading
    statuses: dict[str, ParamStatus]

    def status(self, param: str) -> ParamStatus:
        return self.statuses[param]

    def value(self, param: str) -> float:
        return float(getattr(self.reading, param))

    def is_low(self, param: str) -> bool:
        return self.statuses[param] in (ParamStatus.LOW, ParamStatus.NEAR_LOW)

    def is_high(self, param: str) -> bool:
        return self.statuses[param] in (ParamStatus.HIGH, ParamStatus.NEAR_HIGH)

    def is_optimal(self, param: str) -> bool:
        return self.statuses[param] is ParamStatus.OPTIMAL

    def all_optimal(self) -> bool:
        return all(s is ParamStatus.OPTIMAL for s in self.statuses.values())


# ---------------------------------------------------------------------------
# Rule base class
# ---------------------------------------------------------------------------
class Rule(ABC):
    """Base class for a single advisory rule."""

    category: Category
    priority: Priority

    @abstractmethod
    def applies(self, ctx: EvaluationContext) -> bool:
        """Return True if this rule should fire for the given context."""

    @abstractmethod
    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        """Return (title, description) for the recommendation."""

    def evaluate(self, ctx: EvaluationContext) -> list[Recommendation]:
        if not self.applies(ctx):
            return []
        title, description = self.build_text(ctx)
        return [
            Recommendation(
                category=self.category,
                title=title,
                description=description,
                priority=self.priority,
                icon=CATEGORY_ICONS[self.category],
            )
        ]


# ---------------------------------------------------------------------------
# Concrete rules
# ---------------------------------------------------------------------------
class LowNitrogenRule(Rule):
    category = Category.COMPOSTING
    priority = Priority.HIGH

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_low("nitrogen")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Increase Nitrogen Levels",
            "Nitrogen is below the optimal range. Apply well-rotted compost or "
            "manure before the next planting cycle to boost nitrogen.",
        )


class LowPhosphorusRule(Rule):
    category = Category.SOIL_FERTILITY
    priority = Priority.MEDIUM

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_low("phosphorus")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Boost Phosphorus",
            "Phosphorus is low. Incorporate bone meal or rock phosphate to "
            "support strong root development.",
        )


class LowPotassiumRule(Rule):
    category = Category.SOIL_FERTILITY
    priority = Priority.MEDIUM

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_low("potassium")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Improve Potassium",
            "Potassium is low. Add wood ash or a potassium-rich amendment to "
            "strengthen plants and improve disease resistance.",
        )


class OrganicMatterRule(Rule):
    category = Category.ORGANIC_MATTER
    priority = Priority.MEDIUM

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_low("nitrogen") and ctx.is_low("phosphorus")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Build Soil Organic Matter",
            "Several nutrients are low. Add organic matter such as compost or "
            "green manure to improve fertility and soil structure.",
        )


class AcidicSoilRule(Rule):
    category = Category.SOIL_PH
    priority = Priority.HIGH

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_low("ph")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Reduce Soil Acidity",
            "Soil pH is below the optimal range (too acidic). Apply agricultural "
            "lime to raise pH toward 6.0–7.5.",
        )


class AlkalineSoilRule(Rule):
    category = Category.SOIL_PH
    priority = Priority.MEDIUM

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_high("ph")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Lower Soil Alkalinity",
            "Soil pH is above the optimal range (too alkaline). Add organic "
            "matter or elemental sulphur to gradually lower pH.",
        )


class LowMoistureIrrigationRule(Rule):
    category = Category.IRRIGATION
    priority = Priority.HIGH

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_low("moisture")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Increase Irrigation",
            "Soil moisture is low. Irrigate to keep moisture within 40–70% for "
            "healthy crop growth.",
        )


class LowMoistureMulchRule(Rule):
    category = Category.MULCHING
    priority = Priority.MEDIUM

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_low("moisture")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Apply Mulch",
            "Mulch the soil surface to reduce evaporation and help retain "
            "moisture between waterings.",
        )


class HighMoistureDrainageRule(Rule):
    category = Category.DRAINAGE
    priority = Priority.MEDIUM

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_high("moisture")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Improve Drainage",
            "Soil moisture is high. Improve drainage to prevent waterlogging "
            "and reduce the risk of root rot.",
        )


class HighSalinityRule(Rule):
    category = Category.SALINITY
    priority = Priority.HIGH

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_high("ec")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Manage Soil Salinity",
            "Electrical conductivity is high, indicating salt build-up. Leach "
            "salts with clean water and avoid over-fertilising.",
        )


class TemperatureRule(Rule):
    category = Category.TEMPERATURE
    priority = Priority.LOW

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_low("temperature") or ctx.is_high("temperature")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        if ctx.is_low("temperature"):
            return (
                "Protect Against Low Temperature",
                "Soil temperature is below optimal. Use mulching or row covers "
                "to retain warmth around the root zone.",
            )
        return (
            "Mitigate High Temperature",
            "Soil temperature is above optimal. Provide shade and mulch to cool "
            "the root zone and reduce moisture loss.",
        )


class CropRotationRule(Rule):
    category = Category.CROP_ROTATION
    priority = Priority.MEDIUM

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.is_low("nitrogen") or ctx.is_low("potassium")

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Practice Crop Rotation",
            "Rotate with legumes (e.g. beans) to naturally restore soil "
            "fertility, fix nitrogen, and break pest and disease cycles.",
        )


class BestPracticesRule(Rule):
    category = Category.BEST_PRACTICES
    priority = Priority.LOW

    def applies(self, ctx: EvaluationContext) -> bool:
        return ctx.all_optimal()

    def build_text(self, ctx: EvaluationContext) -> tuple[str, str]:
        return (
            "Maintain Current Practices",
            "All measured parameters are within optimal ranges. Continue your "
            "current soil management and monitoring practices.",
        )


# Ordered registry of rules executed by the engine.
DEFAULT_RULES: list[Rule] = [
    AcidicSoilRule(),
    AlkalineSoilRule(),
    LowNitrogenRule(),
    LowPhosphorusRule(),
    LowPotassiumRule(),
    OrganicMatterRule(),
    LowMoistureIrrigationRule(),
    LowMoistureMulchRule(),
    HighMoistureDrainageRule(),
    HighSalinityRule(),
    TemperatureRule(),
    CropRotationRule(),
    BestPracticesRule(),
]


# ---------------------------------------------------------------------------
# Engine
# ---------------------------------------------------------------------------
class RuleEngine:
    """Runs the rule registry against a reading and aggregates the result."""

    def __init__(
        self,
        rules: list[Rule] | None = None,
        thresholds: dict[str, ParameterThreshold] | None = None,
    ) -> None:
        self.rules = rules if rules is not None else DEFAULT_RULES
        self.thresholds = thresholds if thresholds is not None else THRESHOLDS

    def run(self, reading: SoilReading) -> AdvisoryResult:
        statuses = {
            param: classify(float(getattr(reading, param)), threshold)
            for param, threshold in self.thresholds.items()
        }
        ctx = EvaluationContext(reading=reading, statuses=statuses)

        recommendations: list[Recommendation] = []
        for rule in self.rules:
            recommendations.extend(rule.evaluate(ctx))

        score = self._score(statuses)
        health = self._health_label(score)
        overall = self._overall_status(score, recommendations)

        return AdvisoryResult(
            soil_health_score=score,
            soil_health=health,
            overall_status=overall,
            generated_at=datetime.now(timezone.utc),
            recommendations=recommendations,
        )

    @staticmethod
    def _score(statuses: dict[str, ParamStatus]) -> int:
        if not statuses:
            return 0
        total = sum(_STATUS_SCORE[s] for s in statuses.values())
        return round(total / len(statuses))

    @staticmethod
    def _health_label(score: int) -> str:
        if score >= HEALTH_GOOD_MIN:
            return HEALTH_GOOD
        if score >= HEALTH_MODERATE_MIN:
            return HEALTH_MODERATE
        return HEALTH_POOR

    @staticmethod
    def _overall_status(score: int, recommendations: list[Recommendation]) -> str:
        has_high = any(r.priority is Priority.HIGH for r in recommendations)
        if score < HEALTH_MODERATE_MIN:
            return STATUS_CRITICAL
        if has_high or score < HEALTH_GOOD_MIN:
            return STATUS_NEEDS_IMPROVEMENT
        return STATUS_HEALTHY
