import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:soil_management_app/services/api/django_api_service.dart';

void main() {
  group('SoilManagementResult.fromJson', () {
    test('parses soilHealthScore and recommendations', () {
      final r = SoilManagementResult.fromJson({
        'soilHealthScore': 82,
        'soilHealth': 'Good',
        'overallStatus': 'Healthy',
        'generatedAt': '2026-06-26T10:00:00Z',
        'recommendations': [
          {
            'category': 'Soil pH',
            'title': 'Reduce Soil Acidity',
            'description': 'Apply lime.',
            'priority': 'High',
            'icon': 'lime',
          }
        ],
      });

      expect(r.soilHealthScore, 82);
      expect(r.soilHealth, 'Good');
      expect(r.overallStatus, 'Healthy');
      expect(r.recommendations.single.category, 'Soil pH');
      expect(r.recommendations.single.icon, 'lime');
    });

    test('defaults missing score to 0 and clamps out-of-range', () {
      expect(SoilManagementResult.fromJson({}).soilHealthScore, 0);
      expect(
        SoilManagementResult.fromJson({'soilHealthScore': 150}).soilHealthScore,
        100,
      );
      expect(
        SoilManagementResult.fromJson({'soilHealthScore': 79.6}).soilHealthScore,
        80,
      );
    });
  });

  group('DjangoApiService.fetchStatus', () {
    test('parses a healthy status response', () async {
      final svc = DjangoApiService(
        client: MockClient((req) async {
          expect(req.url.path, '/api/v1/status/');
          return http.Response(
            '{"status":"ok","apiVersion":"1.0.0","rulesetVersion":"1.0.0","firebase":true}',
            200,
          );
        }),
      );
      final status = await svc.fetchStatus();
      expect(status.apiVersion, '1.0.0');
      expect(status.firebaseReady, true);
    });

    test('maps 500 to ApiErrorType.server', () async {
      final svc = DjangoApiService(
        client: MockClient((req) async => http.Response('err', 500)),
      );
      await expectLater(
        svc.fetchStatus(),
        throwsA(isA<ApiException>()
            .having((e) => e.type, 'type', ApiErrorType.server)),
      );
    });

    test('maps malformed body to ApiErrorType.badResponse', () async {
      final svc = DjangoApiService(
        client: MockClient((req) async => http.Response('not-json', 200)),
      );
      await expectLater(
        svc.fetchStatus(),
        throwsA(isA<ApiException>()
            .having((e) => e.type, 'type', ApiErrorType.badResponse)),
      );
    });

    test('maps a socket failure to ApiErrorType.offline', () async {
      final svc = DjangoApiService(
        client: MockClient((req) async => throw const SocketException('down')),
      );
      await expectLater(
        svc.fetchStatus(),
        throwsA(isA<ApiException>().having(
            (e) => e.type, 'type', ApiErrorType.offline)),
      );
    });

    test('maps a timeout to ApiErrorType.timeout', () async {
      final svc = DjangoApiService(
        client: MockClient((req) async => throw TimeoutException('slow')),
      );
      await expectLater(
        svc.fetchStatus(),
        throwsA(isA<ApiException>()
            .having((e) => e.type, 'type', ApiErrorType.timeout)),
      );
    });
  });
}
