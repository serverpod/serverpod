import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_test_server/server.dart' as server;
import 'package:serverpod_test/serverpod_test.dart';

/// The URL of the server started by [withTestServer], with a trailing slash.
late String serverUrl;

/// Starts the auth test server for the tests of the enclosing file.
///
/// The server runs from the sibling `serverpod_auth_test_server` package in
/// test mode on a free port, against a database of its own on the shared
/// embedded postmaster, and is shut down in `tearDownAll`.
void withTestServer() {
  Serverpod? pod;
  EphemeralTestDatabase? database;

  setUpAll(() async {
    final serverDirectory = Directory.fromUri(
      Directory.current.uri.resolve('../serverpod_auth_test_server/'),
    );
    final databaseName = TestDatabaseManager.generateDatabaseName();

    database = await EphemeralTestDatabase.create(
      runMode: ServerpodRunMode.test,
      databaseName: databaseName,
      serverDirectory: serverDirectory,
    );
    pod = await server.run(
      ['--mode', ServerpodRunMode.test, '--apply-migrations'],
      serverDirectory: serverDirectory,
      configOverride: (config) => config.copyWith(
        database: (config.database! as PostgresDatabaseConfig).withName(
          databaseName,
        ),
      ),
    );
    serverUrl = 'http://localhost:${pod!.server.port}/';
  });

  tearDownAll(() async {
    try {
      await pod?.shutdown(exitProcess: false);
    } finally {
      await database?.drop();
    }
  });
}
