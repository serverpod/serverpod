import 'dart:io';

import 'package:test/test.dart';

void main() {
  late ProcessResult result;

  group(
      'Given a serverpod passwords file with the secret service and the environment variable SERVERPOD_DATABASE_PASSWORD is set when loading the passwords',
      () {
    setUpAll(() async {
      result = await Process.run(
        'dart',
        ['run', 'runner.dart'],
        environment: {
          'SERVERPOD_DATABASE_PASSWORD': 'db_password',
        },
        workingDirectory: 'test_integration/assets/load_passwords',
      );
      stderr.writeln(result.stderr);
    });

    test('then the loading of the config was successful', () {
      expect(result.exitCode, 0);
    });

    test('then the database password is set', () {
      expect(result.stdout, contains('database: db_password'));
    });

    test('then the service secret is set', () {
      expect(
        result.stdout,
        contains('serviceSecret: development-service-secret'),
      );
    });
  });

  group(
      'Given a serverpod passwords file with the secret service and the environment variable for the secret service is also set when loading the passwords',
      () {
    setUpAll(() async {
      result = await Process.run(
        'dart',
        ['run', 'runner.dart'],
        environment: {
          'SERVERPOD_SERVICE_SECRET': 'my_service_secret',
        },
        workingDirectory: 'test_integration/assets/load_passwords',
      );
      stderr.writeln(result.stderr);
    });

    test('then the loading of the config was successful', () {
      expect(result.exitCode, 0);
    });

    test('then the service secret is set from env', () {
      expect(
        result.stdout,
        contains('serviceSecret: my_service_secret'),
      );
    });
  });
}
