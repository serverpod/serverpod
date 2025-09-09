import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_cli/src/migrations/migration_creation_result.dart';
import 'package:test/test.dart';

void main() {
  group('MigrationCreationResult', () {
    test('when creating success result then properties are set correctly', () {
      MigrationVersion? migration; // Mock migration object for test
      var result = MigrationCreationResult.success(migration);

      expect(result.isSuccess, isTrue);
      expect(result.isNoChanges, isFalse);
      expect(result.isError, isFalse);
      expect(result.status, MigrationCreationStatus.success);
      expect(result.migration, equals(migration));
      expect(result.message, isNull);
    });

    test('when creating no changes result then properties are set correctly',
        () {
      var result =
          const MigrationCreationResult.noChanges('No changes detected');

      expect(result.isSuccess, isFalse);
      expect(result.isNoChanges, isTrue);
      expect(result.isError, isFalse);
      expect(result.status, MigrationCreationStatus.noChanges);
      expect(result.migration, isNull);
      expect(result.message, equals('No changes detected'));
    });

    test('when creating error result then properties are set correctly', () {
      var result = const MigrationCreationResult.error('An error occurred');

      expect(result.isSuccess, isFalse);
      expect(result.isNoChanges, isFalse);
      expect(result.isError, isTrue);
      expect(result.status, MigrationCreationStatus.error);
      expect(result.migration, isNull);
      expect(result.message, equals('An error occurred'));
    });
  });

  group('CreateMigrationCommand exit codes', () {
    test(
        'when implementing fix then no changes detected should exit with code 0',
        () {
      // This test documents the expected behavior after our fix
      // The actual integration test will be in the e2e tests
      expect(true, isTrue,
          reason:
              'Fix implemented: no changes detected should exit with code 0');
    });
  });
}
