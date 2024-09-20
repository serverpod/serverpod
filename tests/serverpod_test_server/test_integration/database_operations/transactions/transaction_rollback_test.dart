import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

class MockTransaction implements Transaction {
  @override
  Future<void> cancel() async {}
}

void main() async {
  var session = await IntegrationTestServer().session();

  test(
      'Given a transaction when rolling back to savepoint and then saving row then committed rows are found in database.',
      () async {
    var data = UniqueData(number: 1, email: 'test@serverpod.dev');
    var data2 = UniqueData(number: 2, email: 'test2@serverpod.dev');
    var data3 = UniqueData(number: 3, email: 'test3@serverpod.dev');
    await session.db.transaction<void>(
      (transaction) async {
        await UniqueData.db.insertRow(session, data, transaction: transaction);

        await session.db.unsafeExecute(
          'SAVEPOINT savepoint1;',
          transaction: transaction,
        );
        await UniqueData.db.insertRow(session, data2, transaction: transaction);
        await session.db.unsafeExecute(
          'ROLLBACK TO SAVEPOINT savepoint1;',
          transaction: transaction,
        );

        await UniqueData.db.insertRow(session, data3, transaction: transaction);
      },
    );

    var fetchedData = await UniqueData.db.find(session);

    expect(fetchedData, isNotEmpty);
    expect(fetchedData, hasLength(2));
    expect(fetchedData.elementAtOrNull(0)?.number, data.number);
    expect(fetchedData.elementAtOrNull(1)?.number, data3.number);
  });
}
