import 'package:serverpod/src/endpoints/insights.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    'Given a database already at the latest migration version',
    (sessionBuilder, _) async {
      final endpoint = InsightsEndpoint();

      test(
        'when applyMigrations is called requesting regular migrations, '
        'then no migrations are reported as applied and integrity verification passes',
        () async {
          final session = sessionBuilder.build();
          final result = await endpoint.applyMigrations(
            session,
            applyRepairMigration: false,
            applyMigrations: true,
          );

          expect(result.migrationsApplied, isNull);
          expect(result.repairMigrationApplied, isNull);
          expect(result.databaseMatchesTargetState, isTrue);
        },
      );

      test(
        'when applyMigrations is called with no work requested, '
        'then no migrations are reported as applied and integrity verification passes',
        () async {
          final session = sessionBuilder.build();
          final result = await endpoint.applyMigrations(
            session,
            applyRepairMigration: false,
            applyMigrations: false,
          );

          expect(result.migrationsApplied, isNull);
          expect(result.repairMigrationApplied, isNull);
          expect(result.databaseMatchesTargetState, isTrue);
        },
      );
    },
  );
}
