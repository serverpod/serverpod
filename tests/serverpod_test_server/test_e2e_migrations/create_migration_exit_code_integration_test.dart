@Timeout(Duration(minutes: 5))

import 'dart:io';

import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/test_service_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var serviceClient = Client(
    serviceServerUrl,
    authenticationKeyManager: TestServiceKeyManager(
      '0',
      'super_SECRET_password',
    ),
  );

  group('Given create-migration exit code behavior', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        serviceClient: serviceClient,
      );
    });

    test('when running create-migration twice in a row then second run exits with code 0', () async {
      var tag = 'exit-code-test';
      
      // First, create a migration with some changes
      var migrationProtocols = {
        'test_table': '''
class: TestTable
table: test_table
fields:
  id: int, primary
  name: String
'''
      };

      var firstExitCode = await MigrationTestUtils.createMigrationFromProtocols(
        protocols: migrationProtocols,
        tag: tag,
      );
      expect(
        firstExitCode,
        0,
        reason: 'First migration creation should succeed',
      );

      // Now run create-migration again with the same schema (no changes)
      var secondExitCode = await MigrationTestUtils.createMigrationFromProtocols(
        protocols: migrationProtocols,
        tag: '${tag}-no-changes',
      );
      
      // This is the key fix: should exit with code 0, not error
      expect(
        secondExitCode,
        0,
        reason: 'Second migration creation with no changes should exit with code 0, not error',
      );
    });

    test('when running create-migration with --check flag and no changes then exits with code 0', () async {
      var tag = 'check-flag-test';
      
      // Create initial migration
      var migrationProtocols = {
        'check_table': '''
class: CheckTable
table: check_table
fields:
  id: int, primary
  value: String
'''
      };

      var firstExitCode = await MigrationTestUtils.createMigrationFromProtocols(
        protocols: migrationProtocols,
        tag: tag,
      );
      expect(firstExitCode, 0);

      // Test --check flag with no changes
      var checkExitCode = await _runCreateMigrationWithArgs([
        '--check',
        '--tag', '${tag}-check',
      ]);
      
      expect(
        checkExitCode,
        0,
        reason: '--check flag with no changes should exit with code 0',
      );
    });

    test('when running create-migration with --empty flag then creates empty migration', () async {
      var tag = 'empty-flag-test';
      
      // Create initial migration
      var migrationProtocols = {
        'empty_table': '''
class: EmptyTable
table: empty_table
fields:
  id: int, primary
'''
      };

      var firstExitCode = await MigrationTestUtils.createMigrationFromProtocols(
        protocols: migrationProtocols,
        tag: tag,
      );
      expect(firstExitCode, 0);

      // Test --empty flag - should create migration even with no changes
      var emptyExitCode = await _runCreateMigrationWithArgs([
        '--empty',
        '--tag', '${tag}-empty',
      ]);
      
      expect(
        emptyExitCode,
        0,
        reason: '--empty flag should create migration and exit with code 0',
      );
    });
  });
}

/// Helper function to run create-migration with specific arguments
Future<int> _runCreateMigrationWithArgs(List<String> additionalArgs) async {
  var result = await Process.run(
    'dart',
    [
      'run',
      'serverpod_cli',
      'create-migration',
      '--verbose',
      '--no-analytics',
      '--experimental-features=all',
      ...additionalArgs,
    ],
    workingDirectory: Directory.current.parent.parent.path, // Go up to serverpod root
  );
  
  return result.exitCode;
}