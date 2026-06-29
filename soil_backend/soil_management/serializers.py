"""
Request/response serializers for the soil-management endpoint.

Input is validated and converted to a :class:`SoilReading`. Output mirrors the
exact camelCase contract the Flutter ``DjangoApiService`` expects, plus the new
``soilHealthScore`` field.
"""
from __future__ import annotations

from rest_framework import serializers

from .schema import SoilReading
from .services import validators as v


class SoilManagementRequestSerializer(serializers.Serializer):
    """Validates the incoming soil reading payload."""

    plotId = serializers.CharField(max_length=128)
    measurementId = serializers.CharField(max_length=128)

    nitrogen = serializers.FloatField(min_value=v.NUTRIENT_MIN)
    phosphorus = serializers.FloatField(min_value=v.NUTRIENT_MIN)
    potassium = serializers.FloatField(min_value=v.NUTRIENT_MIN)
    ph = serializers.FloatField(min_value=v.PH_MIN, max_value=v.PH_MAX)
    moisture = serializers.FloatField(min_value=v.MOISTURE_MIN, max_value=v.MOISTURE_MAX)
    temperature = serializers.FloatField(
        min_value=v.TEMPERATURE_MIN, max_value=v.TEMPERATURE_MAX
    )
    ec = serializers.FloatField(min_value=v.EC_MIN)

    def to_reading(self) -> SoilReading:
        """Build a SoilReading from validated data."""
        d = self.validated_data
        return SoilReading(
            plot_id=d["plotId"],
            measurement_id=d["measurementId"],
            nitrogen=float(d["nitrogen"]),
            phosphorus=float(d["phosphorus"]),
            potassium=float(d["potassium"]),
            ph=float(d["ph"]),
            moisture=float(d["moisture"]),
            temperature=float(d["temperature"]),
            ec=float(d["ec"]),
        )


class RecommendationSerializer(serializers.Serializer):
    """Serializes a single Recommendation dataclass.

    ``category`` and ``priority`` are StrEnum members (subclasses of ``str``),
    so CharField renders their string values directly.
    """

    category = serializers.CharField()
    title = serializers.CharField()
    description = serializers.CharField()
    priority = serializers.CharField()
    icon = serializers.CharField()


class SoilManagementResponseSerializer(serializers.Serializer):
    """Serializes an AdvisoryResult into the client JSON contract."""

    soilHealthScore = serializers.IntegerField(source="soil_health_score")
    soilHealth = serializers.CharField(source="soil_health")
    overallStatus = serializers.CharField(source="overall_status")
    generatedAt = serializers.DateTimeField(source="generated_at")
    recommendations = RecommendationSerializer(many=True)
