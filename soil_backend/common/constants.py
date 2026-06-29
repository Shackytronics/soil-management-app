"""
Cross-cutting constants and enums shared across the backend.

Single source of truth for: API/ruleset versions, recommendation priorities,
recommendation categories, soil-health score bands, and overall-status labels.
"""
from __future__ import annotations

from enum import StrEnum

# Versions surfaced by /api/v1/version/ and /api/v1/status/.
API_VERSION = "1.0.0"
RULESET_VERSION = "1.0.0"


class Priority(StrEnum):
    """Recommendation urgency."""

    HIGH = "High"
    MEDIUM = "Medium"
    LOW = "Low"


class Category(StrEnum):
    """Recommendation categories supported by the rule engine."""

    SOIL_FERTILITY = "Soil Fertility"
    SOIL_PH = "Soil pH"
    IRRIGATION = "Irrigation"
    ORGANIC_MATTER = "Organic Matter"
    MULCHING = "Mulching"
    COMPOSTING = "Composting"
    DRAINAGE = "Drainage"
    TEMPERATURE = "Temperature"
    SALINITY = "Salinity"
    BEST_PRACTICES = "Best Farming Practices"
    CROP_ROTATION = "Crop Rotation"


# Soil-health score bands (0-100) -> label.
HEALTH_GOOD_MIN = 70
HEALTH_MODERATE_MIN = 40
HEALTH_GOOD = "Good"
HEALTH_MODERATE = "Moderate"
HEALTH_POOR = "Poor"

# Overall status labels.
STATUS_HEALTHY = "Healthy"
STATUS_NEEDS_IMPROVEMENT = "Needs Improvement"
STATUS_CRITICAL = "Critical"
