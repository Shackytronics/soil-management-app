"""
Reusable domain validation bounds and helpers.

Defines the *physically sensible* limits used by the request serializer. These
are deliberately wider than the agronomic "optimal" THRESHOLDS — a reading can
be valid (parseable) yet still trigger recommendations.
"""
from __future__ import annotations

# Hard physical bounds for incoming values.
NUTRIENT_MIN = 0.0          # mg/kg (N, P, K)
PH_MIN, PH_MAX = 0.0, 14.0
MOISTURE_MIN, MOISTURE_MAX = 0.0, 100.0
TEMPERATURE_MIN, TEMPERATURE_MAX = -20.0, 80.0
EC_MIN = 0.0                # mS/cm


def is_finite_number(value: object) -> bool:
    """Return True if value is a real, finite number."""
    if isinstance(value, bool):
        return False
    if not isinstance(value, (int, float)):
        return False
    return value == value and value not in (float("inf"), float("-inf"))
