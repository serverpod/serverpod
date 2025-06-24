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
    test('when calling `count` then an error is thrown.', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.count(
            session,
            where: (_) => Constant.bool(true),
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });
  });

  test(
      'Given inserting an object inside a transaction that is cancelled when calling `count`'
      'inside the transaction then should return 1 but outside the transaction should return 0.',
      () async {
    await session.db.transaction(
      (transaction) async {
        await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.dev'),
          transaction: transaction,
        );

        var count = await UniqueData.db.count(
          session,
          where: (_) => Constant.bool(true),
          transaction: transaction,
        );

        expect(count, 1);

        await transaction.cancel();
      },
    );

    await expectLater(
        UniqueData.db.count(
          session,
          where: (_) => Constant.bool(true),
        ),
        completion(0));
  });
}
