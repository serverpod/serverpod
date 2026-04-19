@Timeout(Duration(minutes: 5))
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:test/test.dart';

void main() {
  const tableName = 'migrated_e2e_hnsw_index_table';

  const protocols = {
    'migrated_e2e_hnsw_index_table':
        '''
class: MigratedE2eHnswIndexTable
table: $tableName
fields:
  v: Vector(3)
indexes:
  v_hnsw:
    fields: v
    type: hnsw
''',
  };

  tearDown(() async {
    await MigrationTestUtils.migrationArtifactsCleanup();
  });

  group(
    'Given a new model with an unsupported index type for the SQLite dialect, '
    'when creating a migration, ',
    () {
      late int exitCode;
      late String stdout;
      late String definitionSql;

      setUp(() async {
        final capturedPrint = StringBuffer();
        exitCode = await runZoned(
          () async {
            return MigrationTestUtils.createMigrationFromProtocols(
              protocols: protocols,
              tag: 'e2e-unsupported-index',
            );
          },
          zoneSpecification: ZoneSpecification(
            print: (self, parent, zone, line) {
              capturedPrint.writeln(line);
              parent.print(zone, line);
            },
          ),
        );

        stdout = capturedPrint.toString();

        expect(
          exitCode,
          0,
          reason: 'Failed to create migration, exit code was not 0.',
        );

        var versions = await MigrationTestUtils.loadMigrationRegistry();
        var latestVersion = versions.last;
        definitionSql = File(
          path.join(
            Directory.current.path,
            'migrations',
            latestVersion,
            'definition.sql',
          ),
        ).readAsStringSync();
      });

      test('then definition.sql lists the new table.', () async {
        expect(definitionSql, contains('CREATE TABLE "$tableName"'));
      });

      test(
        'then definition.sql does not contain the unsupported index.',
        () async {
          expect(definitionSql.toLowerCase(), isNot(contains('using hnsw')));
        },
      );

      test(
        'then a warning is logged that unsupported indexes were skipped.',
        () async {
          final msg =
              'The following indexes will be skipped due to unsupported types';
          expect(stdout, contains(msg));

          final indexMentions = stdout
              .split('\n')
              .where((line) => line.contains('- v_hnsw (hnsw)'));

          // Ensure only one mention, with no duplicates.
          expect(indexMentions, hasLength(1));
        },
      );
    },
  );
}
