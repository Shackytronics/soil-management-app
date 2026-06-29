"""
Soil-management API view.

POST /api/v1/soil-management/
  Auth : Firebase Bearer token (required)
  Body : { plotId, measurementId, nitrogen, phosphorus, potassium,
           ph, moisture, temperature, ec }
  200  : { soilHealthScore, soilHealth, overallStatus, generatedAt,
           recommendations[] }
"""
from __future__ import annotations

from rest_framework import status
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.views import APIView

from authentication.authentication import FirebaseAuthentication
from authentication.permissions import IsFirebaseAuthenticated

from .serializers import (
    SoilManagementRequestSerializer,
    SoilManagementResponseSerializer,
)
from .services.recommendation_service import generate_advisory


class SoilManagementView(APIView):
    """Generate a rule-based advisory for a single soil measurement."""

    authentication_classes = [FirebaseAuthentication]
    permission_classes = [IsFirebaseAuthenticated]

    def post(self, request: Request) -> Response:
        request_serializer = SoilManagementRequestSerializer(data=request.data)
        request_serializer.is_valid(raise_exception=True)

        reading = request_serializer.to_reading()
        result = generate_advisory(reading)

        response_serializer = SoilManagementResponseSerializer(result)
        return Response(response_serializer.data, status=status.HTTP_200_OK)
