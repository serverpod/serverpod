import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_client.dart';

import 'utils/test_storage.dart';

void main() {
  final storage = TestStorage();

  group('Given a `Client` declaration', () {
    group('when creating the session manager directly', () {
      final client = Client('http://localhost:8080/');
      final authSessionManager = ClientAuthSessionManager(storage: storage);

      test('then accessing `client.auth` throws.', () {
        expect(() => client.auth, throwsStateError);
      });

      test('then `client` has no authKeyProvider.', () {
        expect(client.authKeyProvider, isNull);
      });

      test('then accessing `authSessionManager.caller` throws.', () {
        expect(() => authSessionManager.caller, throwsStateError);
      });
    });

    group('when passing `Caller` to the session manager', () {
      final client = Client('http://localhost:8080/');

      final authSessionManager = ClientAuthSessionManager(
        storage: storage,
        caller: client.modules.serverpod_auth_core,
      );

      test('then accessing `client.auth` throws.', () {
        expect(() => client.auth, throwsStateError);
      });

      test('then `client` has no authKeyProvider.', () {
        expect(client.authKeyProvider, isNull);
      });

      test('then `caller` is available.', () {
        expect(authSessionManager.caller, isNotNull);
      });
    });
  });

  group('when using the `authSessionManager` extension', () {
    final client = Client('http://localhost:8080/')
      ..authSessionManager = ClientAuthSessionManager(storage: storage);

    test('then `client.auth` is available.', () {
      expect(client.auth, isNotNull);
    });

    test('then `client` has authKeyProvider set.', () {
      expect(client.authKeyProvider, isNotNull);
      expect(identical(client.authKeyProvider, client.auth), isTrue);
    });

    test('then `authSessionManager.caller` is available.', () {
      expect(client.auth.caller, isNotNull);
    });
  });

  group('Given more than one Client sharing the same auth session manager', () {
    final sharedSessionManager = ClientAuthSessionManager(storage: storage);

    final client1 = Client('http://localhost:8080/')
      ..authSessionManager = sharedSessionManager;
    final client2 = Client('http://localhost:8080/')
      ..authSessionManager = sharedSessionManager;

    test('when accessing `client.auth` then it is the same instance.', () {
      expect(client1.auth, sharedSessionManager);
      expect(client1.auth, client2.auth);
    });

    test('when retrieving caller from `client.auth` '
        'then it is the caller from the latest configured client.', () {
      expect(sharedSessionManager.caller, client2.modules.serverpod_auth_core);
    });
  });
}
