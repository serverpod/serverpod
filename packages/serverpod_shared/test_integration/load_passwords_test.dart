import 'dart:io';

import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late ProcessResult result;

  group(
      'Given a serverpod passwords file with the secret service and the environment variable SERVERPOD_DATABASE_PASSWORD is set when loading the passwords',
      () {
    var dbPassword = const Uuid().v4();

    setUpAll(() async {
      result = await Process.run(
        'dart',
        ['run', 'runner.dart'],
        environment: {
          'SERVERPOD_DATABASE_PASSWORD': dbPassword,
        },
        workingDirectory: 'test_integration/assets/load_passwords',
      );
      stderr.writeln(result.stderr);
    });

    test('then the loading of the config was successful', () {
      expect(result.exitCode, 0);
    });

    test('then the database password is set', () {
      expect(result.stdout, contains('database: $dbPassword'));
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
    var serviceSecret = const Uuid().v4();

    setUpAll(() async {
      result = await Process.run(
        'dart',
        ['run', 'runner.dart'],
        environment: {
          'SERVERPOD_SERVICE_SECRET': serviceSecret,
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
        contains('serviceSecret: $serviceSecret'),
      );
    });
  });

  group(
      'Given no serverpod passwords file exists but the env variable SERVERPOD_DATABASE_PASSWORD is set when loading the passwords',
      () {
    var dbPassword = const Uuid().v4();

    setUpAll(() async {
      result = await Process.run(
        'dart',
        ['run', 'runner_missing_passwords.dart'],
        environment: {
          'SERVERPOD_DATABASE_PASSWORD': dbPassword,
        },
        workingDirectory: 'test_integration/assets/load_passwords',
      );
      stderr.writeln(result.stderr);
    });

    test('then the loading of the config was successful', () {
      expect(result.exitCode, 0);
    });

    test('then the database password is set', () {
      expect(result.stdout, contains('database: $dbPassword'));
    });

    test('then the service secret is not set', () {
      expect(
        result.stdout,
        isNot(contains('serviceSecret')),
      );
    });
  });

  group(
      'Given an empty serverpod passwords file and the env variable SERVERPOD_DATABASE_PASSWORD is set when loading the passwords',
      () {
    var dbPassword = const Uuid().v4();

    setUpAll(() async {
      result = await Process.run(
        'dart',
        ['run', 'runner_empty_passwords.dart'],
        environment: {
          'SERVERPOD_DATABASE_PASSWORD': dbPassword,
        },
        workingDirectory: 'test_integration/assets/load_passwords',
      );
      stderr.writeln(result.stderr);
    });

    test('then the loading of the config was successful', () {
      expect(result.exitCode, 0);
    });

    test('then the database password is set', () {
      expect(result.stdout, contains('database: $dbPassword'));
    });

    test('then the service secret is not set', () {
      expect(
        result.stdout,
        isNot(contains('serviceSecret')),
      );
    });
  });
}
