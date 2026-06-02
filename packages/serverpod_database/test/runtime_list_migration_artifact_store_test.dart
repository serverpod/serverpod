import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given unsorted runtime migrations, when listing versions, then they are returned in ascending order',
    () async {
      final store = RuntimeListMigrationArtifactStore(
        [
          const MigrationVersionSql(
            version: '20240101000000002',
            moduleName: 'test',
            definitionSql: 'definition-2',
            migrationSql: 'migration-2',
          ),
          const MigrationVersionSql(
            version: '20240101000000001',
            moduleName: 'test',
            definitionSql: 'definition-1',
            migrationSql: 'migration-1',
          ),
          const MigrationVersionSql(
            version: '20240101000000002-a',
            moduleName: 'test',
            definitionSql: 'definition-2a',
            migrationSql: 'migration-2a',
          ),
        ],
        moduleName: 'test',
      );

      expect(await store.listVersions(), [
        '20240101000000001',
        '20240101000000002',
        '20240101000000002-a',
      ]);
    },
  );

  test(
    'Given a runtime migration store, when reading a migration by version, then the matching migration is returned',
    () async {
      final store = RuntimeListMigrationArtifactStore(
        [
          const MigrationVersionSql(
            version: '20240101000000002',
            moduleName: 'test',
            definitionSql: 'definition-2',
            migrationSql: 'migration-2',
          ),
          const MigrationVersionSql(
            version: '20240101000000001',
            moduleName: 'test',
            definitionSql: 'definition-1',
            migrationSql: 'migration-1',
          ),
        ],
        moduleName: 'test',
      );

      final migration = await store.readVersionSql('20240101000000001');

      expect(migration, isNotNull);
      expect(migration?.definitionSql, 'definition-1');
      expect(migration?.moduleName, 'test');
      expect(await store.loadDefinitionModuleName('20240101000000001'), 'test');
      expect(await store.readVersionSql('missing'), isNull);
    },
  );

  test(
    'Given duplicate runtime migration versions when creating the store then it throws ArgumentError',
    () {
      expect(
        () => RuntimeListMigrationArtifactStore(
          [
            const MigrationVersionSql(
              version: '20240101000000001',
              moduleName: 'test',
              definitionSql: 'definition-1',
              migrationSql: 'migration-1',
            ),
            const MigrationVersionSql(
              version: '20240101000000001',
              moduleName: 'test',
              definitionSql: 'definition-1b',
              migrationSql: 'migration-1b',
            ),
          ],
          moduleName: 'test',
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );
}
