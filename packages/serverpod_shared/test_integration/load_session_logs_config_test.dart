import 'dart:io';
import 'package:test/test.dart';

void main() {
  late ProcessResult result;

  group('Given a serverpod config with session logs and database support', () {
    setUpAll(() async {
      result = await Process.run(
        'dart',
        ['run', 'session_logs_db_runner.dart'],
        environment: {},
        workingDirectory: 'test_integration/assets/load_config',
      );
      stderr.writeln(result.stderr);
    });

    test(
        'when the loading of the config was successful then the exit code should be zero',
        () {
      expect(result.exitCode, 0, reason: 'The exit code should be zero');
    });

    test(
        'when the config is loaded, then the session persistent logging is enabled as per configuration',
        () async {
      expect(result.stdout, contains('session persistent log enabled: true'));
    });

    test(
        'when the config is loaded, then the session console logging is enabled as per configuration',
        () async {
      expect(result.stdout, contains('session console log enabled: true'));
    });
  });

  group('Given a serverpod config with session logs but no database support',
      () {
    setUpAll(() async {
      result = await Process.run(
        'dart',
        ['run', 'session_logs_no_db_runner.dart'],
        environment: {},
        workingDirectory: 'test_integration/assets/load_config',
      );
      stderr.writeln(result.stderr);
    });

    test(
        'when the loading of the config was successful then the exit code should be zero',
        () {
      expect(result.exitCode, 0, reason: 'The exit code should be zero');
    });

    test(
        'when the config is loaded, then the session persistent logging is disabled due to missing database support',
        () async {
      expect(
        result.stdout,
        contains(
          'Warning: The `persistentEnabled` setting was enabled in the configuration, but this project was created without database support. '
          'Persistent logging is only available when the database is enabled, so the value will be overridden and disabled.',
        ),
      );
      expect(result.stdout, contains('session persistent log enabled: false'));
    });

    test(
        'when the config is loaded, then the session console logging is enabled as per configuration',
        () async {
      expect(result.stdout, contains('session console log enabled: true'));
    });
  });

  group(
      'Given a serverpod config with environment variables overriding session logs',
      () {
    setUpAll(() async {
      result = await Process.run(
        'dart',
        ['run', 'session_logs_no_db_runner.dart'],
        environment: {
          'SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED': 'false',
          'SERVERPOD_SESSION_CONSOLE_LOG_ENABLED': 'false',
        },
        workingDirectory: 'test_integration/assets/load_config',
      );
      stderr.writeln(result.stderr);
    });

    test(
        'when the loading of the config was successful then the exit code should be zero',
        () {
      expect(result.exitCode, 0, reason: 'The exit code should be zero');
    });

    test(
        'when the config is loaded, then the session persistent logging is disabled by environment variable',
        () async {
      expect(result.stdout, contains('session persistent log enabled: false'));
    });

    test(
        'when the config is loaded, then the session console logging is disabled by environment variable',
        () async {
      expect(result.stdout, contains('session console log enabled: false'));
    });
  });

  group(
      'Given a serverpod config without session logs configured and no environment variables',
      () {
    setUpAll(() async {
      result = await Process.run(
        'dart',
        ['run', 'runner.dart'],
        environment: {},
        workingDirectory: 'test_integration/assets/load_config',
      );
    });

    test(
        'when the loading of the config was successful then the exit code should be zero',
        () {
      expect(result.exitCode, 0, reason: 'The exit code should be zero');
    });

    test(
        'when the config is loaded, then the session persistent logging is not present by default',
        () async {
      expect(result.stdout, isNot(contains('session persistent log enabled')));
    });

    test(
        'when the config is loaded, then the session console logging is not present by default',
        () async {
      expect(result.stdout, isNot(contains('session console log enabled')));
    });
  });
}
