import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given transaction call in test',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      test(
          'when database exception occurs '
          'then should not fail `dart test` by leaking exceptions', () async {
        var future = session.db.transaction((tx) async {
          var data = UniqueData(number: 1, email: 'test@test.com');
          await UniqueData.db.insertRow(session, data);
          await UniqueData.db.insertRow(session, data);
        });

        // Even though this exception is caught in this test, due to how transactions work
        // the exception will be re-thrown when the top level test transaction is canceled.
        // If the top level transaction error is not caught this test will fail.
        // Therefore, this test validates that the exception is caught on the top level
        // and does not fail the dart test runner.
        await expectLater(future, throwsA(isA<DatabaseException>()));
      });

      test(
          'when next test is run '
          'then database operations should still work', () async {
        await SimpleData.db.insertRow(session, SimpleData(num: 1));

        expect(await SimpleData.db.find(session), hasLength(1));
      });
    },
  );

  group('Demontrate transaction difference between prod and test tools', () {
    withServerpod(
      'Given transaction call in test with database rollbacks enabled (default)',
      (sessionBuilder, endpoints) {
        var session = sessionBuilder.build();
        test(
            'when database exception occurs '
            'then transaction WILL NOT throw exception if it was caught in the transaction',
            () async {
          var future = session.db.transaction((tx) async {
            var data = UniqueData(number: 1, email: 'test@test.com');
            try {
              await UniqueData.db.insertRow(session, data);
              await UniqueData.db.insertRow(session, data);
            } catch (_) {}
          });

          // ATTENTION: This does not throw in test tools when rollbacks are enabled,
          // but does throw in production environment where rollbacks are disabled!
          await expectLater(future, completes);
        });
      },
    );

    withServerpod(
      'Given transaction call in test with database rollbacks disabled',
      (sessionBuilder, endpoints) {
        var session = sessionBuilder.build();

        test(
            'when database exception occurs '
            'then transaction WILL throw exception even if it was caught in the transaction',
            () async {
          var future = session.db.transaction((tx) async {
            var data = UniqueData(number: 1, email: 'test@test.com');
            try {
              await UniqueData.db.insertRow(session, data, transaction: tx);
              await UniqueData.db.insertRow(session, data, transaction: tx);
            } catch (_) {}
          });

          // ATTENTION: This does not throw in test tools when rollbacks are enabled,
          // but does throw in production environment where rollbacks are disabled!
          await expectLater(future, throwsA(isA<Exception>()));
        });
      },
      rollbackDatabase: RollbackDatabase.disabled,
    );
  });
}
