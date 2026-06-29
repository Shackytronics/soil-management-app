"""
Domain data structures (plain dataclasses — NOT ORM models).

These map 1:1 onto the request/response JSON contract and onto the rule engine
inputs/outputs. No database row ever exists.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime

from common.constants import Category, Priority


@dataclass(frozen=True)
class SoilReading:
    """Validated soil measurement supplied by the Flutter client."""

    plot_id: str
    measurement_id: str
    nitrogen: float
    phosphorus: float
    potassium: float
    ph: float
    moisture: float
    temperature: float
    ec: float


@dataclass(frozen=True)
class Recommendation:
    """A single rule-based advisory item."""

    category: Category
    title: str
    description: str
    priority: Priority
    icon: str


@dataclass
class AdvisoryResult:
    """Full advisory returned for one measurement."""

    soil_health_score: int
    soil_health: str
    overall_status: str
    generated_at: datetime
    recommendations: list[Recommendation] = field(default_factory=list)
