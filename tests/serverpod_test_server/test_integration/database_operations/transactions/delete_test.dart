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
    test('when calling `deleteWhere` then an error is thrown.', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.deleteWhere(
            session,
            where: (_) => Constant.bool(true),
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });

    test('when calling `delete` then an error is thrown.', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.delete(
            session,
            [UniqueData(number: 1, email: '')],
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });

    test('when calling `deleteRow` then an error is thrown.', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.deleteRow(
            session,
            UniqueData(number: 1, email: ''),
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });
  });

  group('Given deleting an object inside a transaction that is committed', () {
    late UniqueData insertedData;
    setUp(() async {
      insertedData = await UniqueData.db.insertRow(
          session, UniqueData(number: 111, email: 'test@serverpod.dev'));
    });

    test('when calling `delete` then does delete the object.', () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.delete(
          session,
          [insertedData],
          transaction: transaction,
        );
      });

      expect(await UniqueData.db.find(session), isEmpty);
    });

    test('when calling `deleteWhere` then does delete the object.', () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
          transaction: transaction,
        );
      });

      expect(await UniqueData.db.find(session), isEmpty);
    });

    test('when calling `deleteRow` then does delete the object.', () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.deleteRow(
          session,
          insertedData,
          transaction: transaction,
        );
      });

      expect(await UniqueData.db.find(session), isEmpty);
    });
  });

  group('Given inserting object and starting transaction that is cancelled',
      () {
    late UniqueData insertedData;
    setUp(() async {
      var data = UniqueData(number: 111, email: 'test@serverpod.dev');

      insertedData = await UniqueData.db.insertRow(
        session,
        data,
      );
    });

    test(
        'when calling `delete` before cancelling then does not delete the object.',
        () async {
      await session.db.transaction(
        (transaction) async {
          await UniqueData.db.delete(
            session,
            [insertedData],
            transaction: transaction,
          );

          await transaction.cancel();
        },
      );

      var fetchedData = await UniqueData.db.find(session);
      expect(fetchedData, hasLength(1));
      expect(fetchedData.first.number, 111);
    });

    test(
        'when calling `deleteWhere` before cancelling then does not delete the object.',
        () async {
      await session.db.transaction(
        (transaction) async {
          await UniqueData.db.deleteWhere(
            session,
            where: (_) => Constant.bool(true),
            transaction: transaction,
          );

          await transaction.cancel();
        },
      );

      var fetchedData = await UniqueData.db.find(session);
      expect(fetchedData, hasLength(1));
      expect(fetchedData.first.number, 111);
    });

    test(
        'when calling `deleteRow` before cancelling then does not delete the object.',
        () async {
      await session.db.transaction(
        (transaction) async {
          await UniqueData.db.deleteRow(
            session,
            insertedData,
            transaction: transaction,
          );

          await transaction.cancel();
        },
      );

      var fetchedData = await UniqueData.db.find(session);
      expect(fetchedData, hasLength(1));
      expect(fetchedData.first.number, 111);
    });
  });
}
