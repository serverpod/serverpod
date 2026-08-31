import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/endpoints/insights.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given insights database access disabled in the configuration',
    configOverride: (config) =>
        config.copyWith(insightsDatabaseAccessEnabled: false),
    (sessionBuilder, _) {
      final endpoint = InsightsEndpoint();

      test(
        'when calling executeSql then an AccessDeniedException is thrown.',
        () async {
          await expectLater(
            endpoint.executeSql(sessionBuilder.build(), 'SELECT 1;'),
            throwsA(isA<AccessDeniedException>()),
          );
        },
      );

      test(
        'when calling runQueries then an AccessDeniedException is thrown.',
        () async {
          await expectLater(
            endpoint.runQueries(sessionBuilder.build(), ['SELECT 1;']),
            throwsA(isA<AccessDeniedException>()),
          );
        },
      );

      test(
        'when calling fetchDatabaseBulkData then an AccessDeniedException is '
        'thrown.',
        () async {
          await expectLater(
            endpoint.fetchDatabaseBulkData(
              sessionBuilder.build(),
              table: 'simple_data',
              startingId: 0,
              limit: 10,
            ),
            throwsA(isA<AccessDeniedException>()),
          );
        },
      );

      test(
        'when calling getDatabaseRowCount then an AccessDeniedException is '
        'thrown.',
        () async {
          await expectLater(
            endpoint.getDatabaseRowCount(
              sessionBuilder.build(),
              table: 'simple_data',
            ),
            throwsA(isA<AccessDeniedException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given insights database access enabled in the configuration',
    configOverride: (config) =>
        config.copyWith(insightsDatabaseAccessEnabled: true),
    (sessionBuilder, _) {
      final endpoint = InsightsEndpoint();

      test(
        'when calling executeSql then the statement is executed.',
        () async {
          await expectLater(
            endpoint.executeSql(sessionBuilder.build(), 'SELECT 1;'),
            completes,
          );
        },
      );

      test(
        'when calling runQueries then the query result is returned.',
        () async {
          var result = await endpoint.runQueries(sessionBuilder.build(), [
            'SELECT 1;',
          ]);
          expect(result.numAffectedRows, 1);
        },
      );
    },
  );
}
