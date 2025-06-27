import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_session_flutter/serverpod_auth_session_flutter.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_server_client.dart';

// serverpod_new_auth_test_server % fvm dart run bin/main.dart --apply-migrations
// docker compose
// run tests in here

void main() {
  test('adds one to input values', () async {
    final sessionManager = SessionManager(
      storage: TestStorage(), // as sahred preferences don't work in CLI test
    );

    final client = Client(
      'http://localhost:8080/',
      authenticationKeyManager: sessionManager,
    );

    final testUser = await client.sessionTest.createTestUser();

    final authentication = await client.sessionTest.createSession(testUser);

    expect(
      await client.sessionTest.checkSession(testUser),
      isFalse,
    );

    await sessionManager.setLoggedIn(authentication);

    expect(
      await client.sessionTest.checkSession(testUser),
      isTrue,
    );
  });
}

class TestStorage extends KeyValueStorage {
  final values = <String, String>{};

  @override
  Future<String?> get(String key) async {
    return values[key];
  }

  @override
  Future<void> set(String key, String? value) async {
    await Future.delayed(const Duration(microseconds: 1));

    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }
}
