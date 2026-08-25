import 'dart:convert';

import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('Given resolved addresses,', () {
    test(
      'when they are encoded and decoded, '
      'then the result equals the input',
      () {
        const addresses = ServerpodAddresses(
          api: 'http://localhost:8080',
          insights: 'http://localhost:8081',
          web: 'http://localhost:8082',
        );

        final decoded = ServerpodAddresses.fromJson(
          jsonDecode(jsonEncode(addresses.toJson())) as Map<String, Object?>,
        );

        expect(decoded.api, addresses.api);
        expect(decoded.insights, addresses.insights);
        expect(decoded.web, addresses.web);
        expect(decoded.toJson(), addresses.toJson());
      },
    );

    test(
      'when they are encoded, '
      'then the payload carries exactly the keys the pod and the CLI agreed on',
      () {
        const addresses = ServerpodAddresses(
          api: 'http://localhost:8080',
          insights: 'http://localhost:8081',
          web: 'http://localhost:8082',
        );

        expect(addresses.toJson(), {
          'api': 'http://localhost:8080',
          'insights': 'http://localhost:8081',
          'web': 'http://localhost:8082',
        });
      },
    );

    test(
      'when a listener is not configured, '
      'then its key is absent rather than null',
      () {
        const addresses = ServerpodAddresses(api: 'http://localhost:8080');

        expect(addresses.toJson().keys, ['api']);
        expect(ServerpodAddresses.fromJson(addresses.toJson()).web, isNull);
      },
    );
  });
}
