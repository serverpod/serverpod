import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  var runMode = 'development';
  var serverId = 'default';
  var passwords = {'serviceSecret': 'longpasswordthatisrequired'};

  group(
    'Given ServerpodConfig with invalid environment variables',
    () {
      test(
        'when invalid websocketPingInterval is provided via environment variable '
        'then ArgumentError is thrown with exit code 1 message',
        () {
          expect(
            () => ServerpodConfig.loadFromMap(
              runMode,
              serverId,
              passwords,
              {},
              environment: {
                'SERVERPOD_WEBSOCKET_PING_INTERVAL': '-1',
              },
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.toString(),
                'message',
                contains(
                  'Invalid SERVERPOD_WEBSOCKET_PING_INTERVAL from environment '
                  'variable: -1. Expected a positive integer greater than 0.',
                ),
              ),
            ),
          );
        },
      );

      test(
        'when zero websocketPingInterval is provided via environment variable '
        'then ArgumentError is thrown with appropriate message',
        () {
          expect(
            () => ServerpodConfig.loadFromMap(
              runMode,
              serverId,
              passwords,
              {},
              environment: {
                'SERVERPOD_WEBSOCKET_PING_INTERVAL': '0',
              },
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.toString(),
                'message',
                contains(
                  'Invalid SERVERPOD_WEBSOCKET_PING_INTERVAL from environment '
                  'variable: 0. Expected a positive integer greater than 0.',
                ),
              ),
            ),
          );
        },
      );

      test(
        'when non-numeric websocketPingInterval is provided via environment variable '
        'then ArgumentError is thrown with appropriate message',
        () {
          expect(
            () => ServerpodConfig.loadFromMap(
              runMode,
              serverId,
              passwords,
              {},
              environment: {
                'SERVERPOD_WEBSOCKET_PING_INTERVAL': 'invalid',
              },
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.toString(),
                'message',
                contains(
                  'Invalid SERVERPOD_WEBSOCKET_PING_INTERVAL from environment '
                  'variable: invalid. Expected a positive integer greater than 0.',
                ),
              ),
            ),
          );
        },
      );

      test(
        'when valid websocketPingInterval is provided via environment variable '
        'then config loads successfully with the correct value',
        () {
          final config = ServerpodConfig.loadFromMap(
            runMode,
            serverId,
            passwords,
            {},
            environment: {
              'SERVERPOD_WEBSOCKET_PING_INTERVAL': '15',
            },
          );

          expect(
            config.websocketPingInterval,
            equals(const Duration(seconds: 15)),
          );
        },
      );
    },
  );
}
