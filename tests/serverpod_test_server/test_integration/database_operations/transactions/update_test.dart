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
    test('when calling `update` then an error is thrown.', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.update(
            session,
            [UniqueData(number: 1, email: '')],
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });

    test('when calling `updateRow` then an error is thrown.', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.updateRow(
            session,
            UniqueData(number: 1, email: ''),
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });
  });

  group('Given updating an object inside a transaction that is committed', () {
    late UniqueData insertedData;
    setUp(() async {
      insertedData = await UniqueData.db.insertRow(
        session,
        UniqueData(number: 111, email: 'test@serverpod.dev'),
      );
    });

    test('when calling `update` then does update the object.', () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.update(
          session,
          [insertedData.copyWith(number: 222)],
          transaction: transaction,
        );
      });

      var updatedData = await UniqueData.db.find(session);
      expect(updatedData, hasLength(1));
      expect(
        updatedData.first.number,
        222,
      );
    });

    test('when calling `updateRow` then does update the object.', () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.updateRow(
          session,
          insertedData.copyWith(number: 222),
          transaction: transaction,
        );
      });

      var updatedData = await UniqueData.db.findFirstRow(session);
      expect(
        updatedData?.number,
        222,
      );
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
        'when calling `update` before cancelling then does not update the object.',
        () async {
      await session.db.transaction(
        (transaction) async {
          await UniqueData.db.update(
            session,
            [insertedData.copyWith(number: 222)],
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
        'when calling `updateRow` before cancelling then does not update the object.',
        () async {
      await session.db.transaction(
        (transaction) async {
          await UniqueData.db.updateRow(
            session,
            insertedData.copyWith(number: 222),
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
