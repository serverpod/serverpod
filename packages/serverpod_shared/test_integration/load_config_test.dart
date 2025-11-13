import 'dart:io';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  late ProcessResult result;

  group(
    'Given a serverpod config without a database entry and environment variables for the database',
    () {
      setUpAll(() async {
        result = await Process.run(
          'dart',
          ['run', 'runner.dart'],
          environment: {
            'SERVERPOD_DATABASE_HOST': 'localhost',
            'SERVERPOD_DATABASE_PORT': '5432',
            'SERVERPOD_DATABASE_NAME': 'serverpod',
            'SERVERPOD_DATABASE_USER': 'postgres',
          },
          workingDirectory: 'test_integration/assets/load_config',
        );
        stderr.writeln(result.stderr);
      });

      test('then the loading of the config was successful', () {
        expect(result.exitCode, 0);
      });

      test('then the database host is configured', () async {
        expect(result.stdout, contains('database host: localhost'));
      });

      test('then the database port is configured', () async {
        expect(result.stdout, contains('database port: 5432'));
      });

      test('then the database name is configured', () async {
        expect(result.stdout, contains('database name: serverpod'));
      });

      test('then the database user is configured', () async {
        expect(result.stdout, contains('database user: postgres'));
      });
    },
  );

  group(
    'Given a serverpod config and an environment variable overriding the database host',
    () {
      setUpAll(() async {
        result = await Process.run(
          'dart',
          ['run', 'runner.dart'],
          environment: {
            'SERVERPOD_API_SERVER_PORT': '3000',
          },
          workingDirectory: 'test_integration/assets/load_config',
        );
        stderr.writeln(result.stderr);
      });

      test('then the loading of the config was successful', () {
        expect(result.exitCode, 0);
      });

      test('then the database host is configured form the env', () async {
        expect(result.stdout, contains('api port: 3000'));
      });
    },
  );

  group(
    'Given a serverpod config without a database entry but only partial environment variables for the database',
    () {
      setUpAll(() async {
        result = await Process.run(
          'dart',
          ['run', 'runner.dart'],
          environment: {
            'SERVERPOD_DATABASE_HOST': 'localhost',
          },
          workingDirectory: 'test_integration/assets/load_config',
        );
      });

      test('then the loading of the config was unsuccessful', () {
        expect(result.exitCode, isNot(0));
      });
    },
  );

  group(
    'Given that the serverpod config does not exist but environment variables are configured for the api server',
    () {
      setUpAll(() async {
        result = await Process.run(
          'dart',
          ['run', 'runner_missing_config.dart'],
          environment: {
            'SERVERPOD_API_SERVER_PORT': '8090',
            'SERVERPOD_API_SERVER_PUBLIC_HOST': 'example.com',
            'SERVERPOD_API_SERVER_PUBLIC_PORT': '8090',
            'SERVERPOD_API_SERVER_PUBLIC_SCHEME': 'https',
          },
          workingDirectory: 'test_integration/assets/load_config',
        );
      });

      test('then the loading of the config was successful', () {
        expect(result.exitCode, 0);
      });

      test('then the api server port is configured', () async {
        expect(result.stdout, contains('api port: 8090'));
      });

      test('then the api server public host is configured', () async {
        expect(result.stdout, contains('api public host: example.com'));
      });

      test('then the api server public port is configured', () async {
        expect(result.stdout, contains('api public port: 8090'));
      });

      test('then the api server public scheme is configured', () async {
        expect(result.stdout, contains('api public scheme: https'));
      });
    },
  );

  group(
    'Given that the serverpod config does not exist and no environment variables are configured',
    () {
      setUpAll(() async {
        result = await Process.run(
          'dart',
          ['run', 'runner_missing_config.dart'],
          environment: {},
          workingDirectory: 'test_integration/assets/load_config',
        );
      });

      test('then the loading of the config was successful', () {
        expect(result.exitCode, 0);
      });

      test('then the default config is loaded', () async {
        expect(result.stdout, ServerpodConfig.defaultConfig().toString());
      });
    },
  );
}
