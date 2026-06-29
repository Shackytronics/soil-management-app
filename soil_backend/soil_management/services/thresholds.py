"""
Single source of truth for all soil parameter thresholds and engine tuning.

NOTHING in the rule logic hardcodes a numeric threshold — every range, "near"
band factor, score weight, and category->icon mapping is defined here. These
ranges intentionally mirror the Flutter app's optimal-range badges so client
and server never disagree.
"""
from __future__ import annotations

from dataclasses import dataclass

from common.constants import Category


@dataclass(frozen=True)
class ParameterThreshold:
    """Optimal inclusive range for a single soil parameter."""

    low: float
    high: float


# Parameter keys MUST match SoilReading attribute names.
THRESHOLDS: dict[str, ParameterThreshold] = {
    "nitrogen": ParameterThreshold(10.0, 30.0),     # mg/kg
    "phosphorus": ParameterThreshold(5.0, 30.0),    # mg/kg
    "potassium": ParameterThreshold(100.0, 300.0),  # mg/kg
    "ph": ParameterThreshold(6.0, 7.5),             # pH
    "moisture": ParameterThreshold(40.0, 70.0),     # %
    "temperature": ParameterThreshold(15.0, 35.0),  # degC
    "ec": ParameterThreshold(0.2, 1.0),             # mS/cm
}

# A value within [low*FACTOR_LOW, high*FACTOR_HIGH] but outside the optimal
# range is treated as "near" (a soft warning) rather than fully "off".
NEAR_LOW_FACTOR = 0.8
NEAR_HIGH_FACTOR = 1.2

# Per-parameter score contributions (averaged into the 0-100 health score).
OPTIMAL_SCORE = 100
NEAR_SCORE = 60
OFF_SCORE = 20

# Category -> icon string. Icons match the keys the Flutter SoilManagementScreen
# already maps, so advisories render with the correct icon and colour.
CATEGORY_ICONS: dict[Category, str] = {
    Category.SOIL_FERTILITY: "fertility",
    Category.SOIL_PH: "lime",
    Category.IRRIGATION: "water",
    Category.ORGANIC_MATTER: "organic",
    Category.MULCHING: "mulch",
    Category.COMPOSTING: "compost",
    Category.DRAINAGE: "conservation",
    Category.TEMPERATURE: "temperature",
    Category.SALINITY: "conservation",
    Category.BEST_PRACTICES: "practice",
    Category.CROP_ROTATION: "practice",
}
