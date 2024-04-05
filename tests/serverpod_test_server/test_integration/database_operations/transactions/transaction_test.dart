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

  tearDown(() async {
    await UniqueData.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  group('Given a transaction that does not match required database transaction',
      () {
    var invalidTransactionType = MockTransaction();
    test('when running a transaction then an error is thrown.', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.findFirstRow(
            session,
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });

    test('when making a query then an error is thrown.', () async {
      expect(
        session.db.unsafeExecute(
          'SELECT 1;',
          transaction: invalidTransactionType,
        ),
        throwsArgumentError,
      );
    });
  });

  test(
      'Given transaction when inserting and then fetching row then the row is found.',
      () async {
    var data = UniqueData(number: 1, email: 'test@serverpod.dev');

    var fetchedData = await session.db.transaction<UniqueData?>(
      (transaction) async {
        await UniqueData.db.insertRow(session, data, transaction: transaction);
        return await UniqueData.db.findFirstRow(
          session,
          transaction: transaction,
        );
      },
    );

    expect(fetchedData, isNotNull);
    var UniqueData(:number, :email) = fetchedData!;
    expect(number, data.number);
    expect(email, data.email);
  });

  test(
      'Given row insertion transaction that is canceled when fetching row then the row is not found in database.',
      () async {
    var data = UniqueData(number: 1, email: 'test@serverpod.dev');
    await session.db.transaction<void>(
      (transaction) async {
        await UniqueData.db.insertRow(session, data, transaction: transaction);
        await transaction.cancel();
      },
    );

    var fetchedData = await UniqueData.db.findFirstRow(session);

    expect(
      fetchedData,
      isNull,
      reason: 'Row was inserted even though transaction was canceled.',
    );
  });

  test(
      'Given a transaction that is canceled when inserting row after transaction is canceled then insertion has no effect',
      () async {
    var data = UniqueData(number: 1, email: 'test@serverpod.dev');
    var data2 = UniqueData(number: 2, email: 'test2@serverpod.dev');
    await session.db.transaction<void>(
      (transaction) async {
        await UniqueData.db.insertRow(session, data, transaction: transaction);
        await transaction.cancel();
        try {
          await UniqueData.db.insertRow(
            session,
            data2,
            transaction: transaction,
          );
        } catch (_) {
          // Ignore
        }
      },
    );

    var fetchedData = await UniqueData.db.findFirstRow(session);

    expect(
      fetchedData,
      isNull,
      reason: 'Row was inserted after transaction was cancelled.',
    );
  });

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
