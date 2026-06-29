"""
Recommendation service — the orchestration layer between the API and the engine.

Keeps the view thin: the view validates input into a :class:`SoilReading` and
calls :func:`generate_advisory`, which runs the rule engine and returns an
:class:`AdvisoryResult`.

(The future AI provider in ``ai_bridge`` would be wired in here — not in this
phase.)
"""
from __future__ import annotations

from ..schema import AdvisoryResult, SoilReading
from .rule_engine import RuleEngine

# A single shared, stateless engine instance (rules hold no per-request state).
_engine = RuleEngine()


def generate_advisory(reading: SoilReading) -> AdvisoryResult:
    """Generate a rule-based soil-management advisory for one reading."""
    return _engine.run(reading)
