import 'dart:io';

import 'package:serverpod/src/server/socket_bind_failure.dart';
import 'package:test/test.dart';

void main() {
  group('Given isAddressAlreadyInUse', () {
    test(
      'when SocketException has macOS EADDRINUSE errno then it returns true',
      () {
        final error = SocketException(
          'Failed to create server socket',
          osError: const OSError('Address already in use', 48),
          address: InternetAddress.loopbackIPv4,
          port: 8080,
        );

        expect(isAddressAlreadyInUse(error), isTrue);
      },
    );

    test(
      'when SocketException has Linux EADDRINUSE errno then it returns true',
      () {
        const error = SocketException(
          'Failed to create server socket',
          osError: OSError('Address already in use', 98),
          port: 8080,
        );

        expect(isAddressAlreadyInUse(error), isTrue);
      },
    );

    test(
      'when SocketException has Windows WSAEADDRINUSE errno then it returns true',
      () {
        const error = SocketException(
          'Failed to create server socket',
          osError: OSError(
            'Only one usage of each socket address '
            '(protocol/network address/port) is normally permitted.',
            10048,
          ),
          port: 8080,
        );

        expect(isAddressAlreadyInUse(error), isTrue);
      },
    );

    test(
      'when SocketException has no error code but message says already in use '
      'then it returns true',
      () {
        const error = SocketException(
          'Failed to create server socket (Address already in use)',
          port: 8080,
        );

        expect(isAddressAlreadyInUse(error), isTrue);
      },
    );

    test(
      'when SocketException is permission denied then it returns false',
      () {
        const error = SocketException(
          'Failed to create server socket',
          osError: OSError('Permission denied', 13),
          port: 80,
        );

        expect(isAddressAlreadyInUse(error), isFalse);
      },
    );

    test(
      'when SocketException is connection refused then it returns false',
      () {
        const error = SocketException(
          'Connection refused',
          osError: OSError('Connection refused', 61),
          port: 8080,
        );

        expect(isAddressAlreadyInUse(error), isFalse);
      },
    );

    test('when error is not a SocketException then it returns false', () {
      expect(isAddressAlreadyInUse(Exception('boom')), isFalse);
    });
  });

  group('Given describeSocketBindFailure', () {
    test(
      'when address is in use then message names the server, port, and '
      'run-mode config file and omits the stack',
      () {
        const error = SocketException(
          'Failed to create server socket',
          osError: OSError('Address already in use', 48),
          port: 8080,
        );

        final failure = describeSocketBindFailure(
          error: error,
          serverLabel: 'API server',
          port: 8080,
          runMode: 'development',
        );

        expect(failure.kind, SocketBindFailureKind.addressInUse);
        expect(failure.omitStackTrace, isTrue);
        expect(failure.userMessage, contains('API server'));
        expect(failure.userMessage, contains('port 8080'));
        expect(failure.userMessage, contains('address already in use'));
        expect(failure.userMessage, contains('config/development.yaml'));
        expect(failure.userMessage, contains('partial start'));
        expect(
          failure.userMessage,
          isNot(contains('another Serverpod already running')),
        );
      },
    );

    test(
      'when run mode is production then the config hint uses production.yaml',
      () {
        const error = SocketException(
          'Failed to create server socket',
          osError: OSError('Address already in use', 98),
          port: 8081,
        );

        final failure = describeSocketBindFailure(
          error: error,
          serverLabel: 'Insights server',
          port: 8081,
          runMode: 'production',
        );

        expect(failure.userMessage, contains('Insights server'));
        expect(failure.userMessage, contains('config/production.yaml'));
        expect(failure.userMessage, isNot(contains('development.yaml')));
      },
    );

    test(
      'when bind fails for another reason then message is generic and stack '
      'is kept',
      () {
        const error = SocketException(
          'Failed to create server socket',
          osError: OSError('Permission denied', 13),
          port: 80,
        );

        final failure = describeSocketBindFailure(
          error: error,
          serverLabel: 'web server',
          port: 80,
          runMode: 'development',
        );

        expect(failure.kind, SocketBindFailureKind.other);
        expect(failure.omitStackTrace, isFalse);
        expect(
          failure.userMessage,
          equals('Failed to bind web server on port 80.'),
        );
        expect(failure.userMessage, isNot(contains('already in use')));
      },
    );
  });
}
