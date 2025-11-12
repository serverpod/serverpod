import 'package:serverpod_auth_core_server/session.dart';
import 'package:test/test.dart';

void main() {
  group('Given AuthSessionsConfig validation', () {
    test(
      'when creating config with valid session key hash pepper then config is created successfully.',
      () {
        expect(
          () => AuthSessionsConfig(
            sessionKeyHashPepper: '1234567890',
          ),
          returnsNormally,
        );
      },
    );

    test(
      'when creating config with empty session key hash pepper then an error is thrown.',
      () {
        expect(
          () => AuthSessionsConfig(
            sessionKeyHashPepper: '',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'when creating config with session key hash pepper less than 10 characters then an error is thrown.',
      () {
        expect(
          () => AuthSessionsConfig(
            sessionKeyHashPepper: '123456789',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'when creating config with valid default session lifetime then config is created successfully.',
      () {
        expect(
          () => AuthSessionsConfig(
            sessionKeyHashPepper: '1234567890',
            defaultSessionLifetime: const Duration(days: 7),
          ),
          returnsNormally,
        );
      },
    );

    test(
      'when creating config with negative default session lifetime then an error is thrown.',
      () {
        expect(
          () => AuthSessionsConfig(
            sessionKeyHashPepper: '1234567890',
            defaultSessionLifetime: const Duration(days: -1),
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'when creating config with valid default session inactivity timeout then config is created successfully.',
      () {
        expect(
          () => AuthSessionsConfig(
            sessionKeyHashPepper: '1234567890',
            defaultSessionInactivityTimeout: const Duration(hours: 2),
          ),
          returnsNormally,
        );
      },
    );

    test(
      'when creating config with negative default session inactivity timeout then an error is thrown.',
      () {
        expect(
          () => AuthSessionsConfig(
            sessionKeyHashPepper: '1234567890',
            defaultSessionInactivityTimeout: const Duration(hours: -1),
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'when creating config with all optional parameters null then config is created successfully.',
      () {
        expect(
          () => AuthSessionsConfig(
            sessionKeyHashPepper: '1234567890',
            defaultSessionLifetime: null,
            defaultSessionInactivityTimeout: null,
          ),
          returnsNormally,
        );
      },
    );
  });
}
