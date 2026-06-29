import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_config.dart';
import '../../data/models/measurement_model.dart';
import '../../data/models/recommendation_model.dart';

/// Classifies failures from the Django REST API so the UI can react sensibly
/// (e.g. fall back to cached Hive recommendations when offline).
enum ApiErrorType { offline, timeout, unauthorized, server, badResponse, unknown }

class ApiException implements Exception {
  ApiException(this.type, this.message);

  final ApiErrorType type;
  final String message;

  bool get isOffline => type == ApiErrorType.offline || type == ApiErrorType.timeout;

  @override
  String toString() => 'ApiException(${type.name}): $message';
}

/// Parsed payload returned by `POST /api/soil-management/`.
///
/// Mirrors the locked response contract:
/// ```json
/// {
///   "soilHealth": "Moderate",
///   "overallStatus": "Needs Improvement",
///   "recommendations": [ { category, title, description, priority, icon } ]
/// }
/// ```
class SoilManagementResult {
  SoilManagementResult({
    required this.soilHealthScore,
    required this.soilHealth,
    required this.overallStatus,
    required this.recommendations,
    required this.generatedAt,
  });

  final int soilHealthScore;
  final String soilHealth;
  final String overallStatus;
  final List<RecommendationItem> recommendations;
  final DateTime generatedAt;

  factory SoilManagementResult.fromJson(Map<String, dynamic> json) {
    final rawList = (json['recommendations'] as List?) ?? const [];
    final items = rawList
        .whereType<Map>()
        .map((e) => RecommendationItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final generatedRaw = json['generatedAt'];
    final generatedAt = generatedRaw is String
        ? (DateTime.tryParse(generatedRaw) ?? DateTime.now())
        : DateTime.now();

    final rawScore = json['soilHealthScore'];
    final score = rawScore is num ? rawScore.round() : 0;

    return SoilManagementResult(
      soilHealthScore: score.clamp(0, 100),
      soilHealth: (json['soilHealth'] ?? 'Unknown').toString(),
      overallStatus: (json['overallStatus'] ?? '').toString(),
      recommendations: items,
      generatedAt: generatedAt,
    );
  }
}

/// Result of the `/api/v1/status/` connectivity probe.
class BackendStatus {
  BackendStatus({
    required this.apiVersion,
    required this.rulesetVersion,
    required this.firebaseReady,
  });

  final String apiVersion;
  final String rulesetVersion;
  final bool firebaseReady;

  factory BackendStatus.fromJson(Map<String, dynamic> json) => BackendStatus(
        apiVersion: (json['apiVersion'] ?? '').toString(),
        rulesetVersion: (json['rulesetVersion'] ?? '').toString(),
        firebaseReady: json['firebase'] == true,
      );
}

/// HTTP client for the Django backend. This is the ONLY place that talks to
/// Django. The Rule-Based Soil Management Engine lives server-side; Flutter
/// only sends a measurement and receives structured recommendations.
class DjangoApiService {
  DjangoApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<SoilManagementResult> fetchSoilManagement(MeasurementModel m) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();

    final body = jsonEncode({
      'plotId': m.plotId,
      'measurementId': m.id,
      'nitrogen': m.nitrogen,
      'phosphorus': m.phosphorus,
      'potassium': m.potassium,
      'ph': m.ph,
      'moisture': m.moisture,
      'temperature': m.temperature,
      'ec': m.ec,
    });

    http.Response res;
    try {
      res = await _client
          .post(
            ApiConfig.soilManagementUri(),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          )
          .timeout(ApiConfig.requestTimeout);
    } on SocketException catch (e) {
      throw ApiException(ApiErrorType.offline, 'No connection to server: $e');
    } on TimeoutException {
      throw ApiException(ApiErrorType.timeout, 'Request timed out');
    } on http.ClientException catch (e) {
      throw ApiException(ApiErrorType.offline, 'Network error: ${e.message}');
    } catch (e) {
      throw ApiException(ApiErrorType.unknown, e.toString());
    }

    if (res.statusCode == 401 || res.statusCode == 403) {
      throw ApiException(ApiErrorType.unauthorized, 'Not authorized (${res.statusCode})');
    }
    if (res.statusCode >= 500) {
      throw ApiException(ApiErrorType.server, 'Server error (${res.statusCode})');
    }
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw ApiException(
        ApiErrorType.badResponse,
        'Unexpected status ${res.statusCode}',
      );
    }

    try {
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      return SoilManagementResult.fromJson(decoded);
    } catch (e) {
      throw ApiException(ApiErrorType.badResponse, 'Malformed response: $e');
    }
  }

  /// Lightweight connectivity probe against `GET /api/v1/status/`.
  /// Throws [ApiException] when the backend is unreachable or errors.
  Future<BackendStatus> fetchStatus() async {
    http.Response res;
    try {
      res = await _client.get(
        ApiConfig.statusUri(),
        headers: const {'Accept': 'application/json'},
      ).timeout(ApiConfig.statusTimeout);
    } on SocketException catch (e) {
      throw ApiException(ApiErrorType.offline, 'No connection to server: $e');
    } on TimeoutException {
      throw ApiException(ApiErrorType.timeout, 'Status request timed out');
    } on http.ClientException catch (e) {
      throw ApiException(ApiErrorType.offline, 'Network error: ${e.message}');
    } catch (e) {
      throw ApiException(ApiErrorType.unknown, e.toString());
    }

    if (res.statusCode != 200) {
      throw ApiException(
        ApiErrorType.server,
        'Status endpoint returned ${res.statusCode}',
      );
    }

    try {
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      return BackendStatus.fromJson(decoded);
    } catch (e) {
      throw ApiException(ApiErrorType.badResponse, 'Malformed status: $e');
    }
  }

  void dispose() => _client.close();
}
