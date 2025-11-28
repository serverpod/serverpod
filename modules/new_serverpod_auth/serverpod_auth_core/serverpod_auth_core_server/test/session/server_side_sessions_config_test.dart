import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

void main() {
  group('Given ServerSideSessionsConfig validation', () {
    test(
      'when creating config with valid session key hash pepper then config is created successfully.',
      () {
        expect(
          () => ServerSideSessionsConfig(
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
          () => ServerSideSessionsConfig(
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
          () => ServerSideSessionsConfig(
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
          () => ServerSideSessionsConfig(
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
          () => ServerSideSessionsConfig(
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
          () => ServerSideSessionsConfig(
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
          () => ServerSideSessionsConfig(
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
          () => ServerSideSessionsConfig(
            sessionKeyHashPepper: '1234567890',
            defaultSessionLifetime: null,
            defaultSessionInactivityTimeout: null,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'when creating config with valid fallback peppers then config is created successfully.',
      () {
        expect(
          () => ServerSideSessionsConfig(
            sessionKeyHashPepper: '1234567890',
            fallbackSessionKeyHashPeppers: ['old-pepper-1', 'old-pepper-2'],
          ),
          returnsNormally,
        );
      },
    );

    test(
      'when creating config with empty fallback peppers list then config is created successfully.',
      () {
        expect(
          () => ServerSideSessionsConfig(
            sessionKeyHashPepper: '1234567890',
            fallbackSessionKeyHashPeppers: [],
          ),
          returnsNormally,
        );
      },
    );

    test(
      'when creating config with invalid fallback pepper then an error is thrown.',
      () {
        expect(
          () => ServerSideSessionsConfig(
            sessionKeyHashPepper: '1234567890',
            fallbackSessionKeyHashPeppers: ['valid-pepper', 'short'],
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'when creating config with empty fallback pepper then an error is thrown.',
      () {
        expect(
          () => ServerSideSessionsConfig(
            sessionKeyHashPepper: '1234567890',
            fallbackSessionKeyHashPeppers: [''],
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
