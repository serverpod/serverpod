import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_session_flutter/serverpod_auth_session_flutter.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_server_client.dart';

// serverpod_new_auth_test_server % fvm dart run bin/main.dart --apply-migrations
// docker compose
// run tests in here

void main() {
  test('adds one to input values', () async {
    final sessionManager = SessionManager();

    final client = Client(
      'http://localhost:8080/',
      authenticationKeyManager: sessionManager,
    );

    // client
  });
}
