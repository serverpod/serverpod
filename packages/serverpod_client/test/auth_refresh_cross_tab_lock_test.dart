import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

import 'test_utils/test_serverpod_client.dart';

void main() {
  group('Given a client on a platform with cross-tab locks', () {
    late _RecordingLockDelegate delegate;

    setUp(() => delegate = _RecordingLockDelegate());

    test(
      'when accessing authRefreshCrossTabLock '
      'then the lock name is scoped by origin and base path.',
      () {
        final client = TestServerpodClient(
          host: Uri.parse('http://localhost:8080/api/'),
          requestDelegate: delegate,
        );

        expect(client.authRefreshCrossTabLock, isNotNull);
        expect(delegate.requestedLockNames, [
          'serverpod-auth-refresh:http://localhost:8080/api',
        ]);
      },
    );

    test(
      'when the host is at the domain root '
      'then the lock name ends with the root path.',
      () {
        final client = TestServerpodClient(
          host: Uri.parse('http://localhost:8080'),
          requestDelegate: delegate,
        );

        client.authRefreshCrossTabLock;

        expect(delegate.requestedLockNames, [
          'serverpod-auth-refresh:http://localhost:8080/',
        ]);
      },
    );

    test(
      'when accessing authRefreshCrossTabLock twice '
      'then the lock is only created once.',
      () {
        final client = TestServerpodClient(
          host: Uri.parse('http://localhost:8080'),
          requestDelegate: delegate,
        );

        final first = client.authRefreshCrossTabLock;
        final second = client.authRefreshCrossTabLock;

        expect(identical(first, second), isTrue);
        expect(delegate.requestedLockNames, hasLength(1));
      },
    );
  });

  test(
    'Given a client whose transport provides no cross-tab locks '
    'when accessing authRefreshCrossTabLock '
    'then it is null.',
    () {
      final client = TestServerpodClient(
        host: Uri.parse('http://localhost:8080'),
        requestDelegate: _LocklessDelegate(),
      );

      expect(client.authRefreshCrossTabLock, isNull);
    },
  );
}

/// Uses the base class's [ServerpodClientRequestDelegate.createCrossTabLock],
/// which returns null.
class _LocklessDelegate extends ServerpodClientRequestDelegate {
  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
    bool authenticated = true,
  }) {
    throw UnimplementedError();
  }

  @override
  void close() {}
}

class _RecordingLockDelegate extends ServerpodClientRequestDelegate {
  final requestedLockNames = <String>[];

  @override
  CrossTabLock? createCrossTabLock(String name) {
    requestedLockNames.add(name);
    return _NoopCrossTabLock();
  }

  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
    bool authenticated = true,
  }) {
    throw UnimplementedError();
  }

  @override
  void close() {}
}

class _NoopCrossTabLock implements CrossTabLock {
  @override
  Future<T> synchronize<T>(Future<T> Function() action) => action();
}
