import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

class MockTransaction implements Transaction {
  @override
  Future<void> cancel() async {}

  @override
  Future<Savepoint> createSavepoint() {
    throw UnimplementedError();
  }

  @override
  Future<void> setRuntimeParameters(RuntimeParametersListBuilder builder) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> runtimeParameters = {};
}

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await UniqueData.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  group('Given a transaction that does not match required database transaction',
      () {
    var invalidTransactionType = MockTransaction();

    test('when calling `insert` then an error is thrown.', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.insert(
            session,
            [UniqueData(number: 1, email: 'test@serverpod.dev')],
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });

    test('when calling `insertRow` then an error is thrown.', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.insertRow(
            session,
            UniqueData(number: 1, email: 'test@serverpod.dev'),
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

  group('Given inserting an object inside a transaction that is committed', () {
    UniqueData data = UniqueData(number: 111, email: 'test@serverpod.dev');

    test('when calling `insert` then does create the object.', () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.insert(
          session,
          [data],
          transaction: transaction,
        );
      });

      var insertedData = await UniqueData.db.find(session);
      expect(insertedData, hasLength(1));
      expect(insertedData.first.number, 111);
    });

    test('when calling `insertRow` then does create the object.', () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.insertRow(
          session,
          data,
          transaction: transaction,
        );
      });

      var insertedData = await UniqueData.db.findFirstRow(session);
      expect(insertedData?.number, 111);
    });
  });

  group('Given starting transaction that is cancelled', () {
    UniqueData data = UniqueData(number: 111, email: 'test@serverpod.dev');

    test(
        'when calling `insert` before cancelling then does not create the object.',
        () async {
      await session.db.transaction(
        (transaction) async {
          await UniqueData.db.insert(
            session,
            [data],
            transaction: transaction,
          );

          await transaction.cancel();
        },
      );

      await expectLater(UniqueData.db.find(session), completion(hasLength(0)));
    });

    test(
        'when calling `insertRow` before cancelling then does not create the object.',
        () async {
      await session.db.transaction(
        (transaction) async {
          await UniqueData.db.insertRow(
            session,
            data,
            transaction: transaction,
          );

          await transaction.cancel();
        },
      );

      await expectLater(UniqueData.db.find(session), completion(hasLength(0)));
    });
  });

  test(
      'Given a transaction that is cancelled when inserting row after transaction is cancelled then insertion has no effect',
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
}
