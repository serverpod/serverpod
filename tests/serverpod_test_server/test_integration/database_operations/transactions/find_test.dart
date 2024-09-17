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

    test('when calling `find` then an error is thrown', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.find(
            session,
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });

    test('when calling `findFirstRow` then an error is thrown', () async {
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

    test('when calling `findById` then an error is thrown', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.findById(
            session,
            1,
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });
  });

  group('Given finding an object inside a transaction that is committed', () {
    test('when calling `find` with transaction then does find the object',
        () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var data = await UniqueData.db.find(
          session,
          transaction: transaction,
        );

        expect(data, hasLength(1));
        expect(data[0].number, 111);
        expect(data[0].email, 'test@serverpod.com');
      });
    });

    test(
        'when calling `find` without transaction then does not find the object',
        () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var data = await UniqueData.db.find(
          session,
        );

        expect(data, hasLength(0));
      });
    });

    test(
        'when calling `findFirstRow` with transaction then does find the object',
        () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var data = await UniqueData.db.findFirstRow(
          session,
          transaction: transaction,
        );

        expect(data, isNot(equals(null)));
        expect(data?.number, 111);
        expect(data?.email, 'test@serverpod.com');
      });
    });

    test(
        'when calling `findFirstRow` without transaction then does not find the object',
        () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var data = await UniqueData.db.findFirstRow(
          session,
        );

        expect(data, equals(null));
      });
    });

    test('when calling `findById` with transaction then does find the object',
        () async {
      await session.db.transaction((transaction) async {
        var insertedData = await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var fetchedData = await UniqueData.db.findById(
          session,
          insertedData.id!,
          transaction: transaction,
        );

        expect(fetchedData, isNot(equals(null)));
        expect(fetchedData?.number, 111);
        expect(fetchedData?.email, 'test@serverpod.com');
      });
    });

    test(
        'when calling `find` without transaction then does not find the object',
        () async {
      await session.db.transaction((transaction) async {
        var insertedData = await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var data = await UniqueData.db.findById(
          session,
          insertedData.id!,
        );

        expect(data, equals(null));
      });
    });
  });
}
