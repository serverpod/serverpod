import 'package:serverpod/serverpod.dart';
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

  tearDown(() async {
    await UniqueData.db.deleteWhere(session, where: (t) => Constant.bool(true));
  });

  test(
      'Given serializable transaction settings when modifying the same value concurrently then one transaction is rolled back.',
      () async {
    var initialValue = 'initial';
    var data = await UniqueData.db
        .insertRow(session, UniqueData(number: 1, email: initialValue));

    var settings = TransactionSettings(
      isolationLevel: IsolationLevel.serializable,
    );

    var update = (int id, Session session, String email) async {
      try {
        await session.db.transaction((t) async {
          var localData = await UniqueData.db.findById(
            session,
            id,
            transaction: t,
          );
          await Future.delayed(Duration(milliseconds: 100));
          await UniqueData.db.updateRow(
            session,
            localData!.copyWith(email: email),
            transaction: t,
          );
        }, settings: settings);
      } catch (e) {
        return false;
      }

      return true;
    };

    var result = await Future.wait([
      update(data.id!, session, 'bob'),
      update(data.id!, session, 'alex'),
      update(data.id!, session, 'jim'),
      update(data.id!, session, 'hank'),
    ]);

    var success = result.where((e) => e).length;
    expect(success, 1);
    var dataAfter = await UniqueData.db.findById(session, data.id!);
    expect(dataAfter?.email, isNot(initialValue));
  });

  test(
      'Given serializable transaction settings when value is modified outside concurrently then transaction is rolled back.',
      () async {
    var initialValue = 'initial';
    var data = await UniqueData.db
        .insertRow(session, UniqueData(number: 1, email: initialValue));

    var settings = TransactionSettings(
      isolationLevel: IsolationLevel.serializable,
    );

    var update = (int id, Session session, String email) async {
      try {
        await session.db.transaction((t) async {
          var localData = await UniqueData.db.findById(
            session,
            id,
            transaction: t,
          );
          await Future.delayed(Duration(milliseconds: 100));
          await UniqueData.db.updateRow(
            session,
            localData!.copyWith(email: email),
            transaction: t,
          );
        }, settings: settings);
      } catch (e) {
        return false;
      }

      return true;
    };
    var success = update(data.id!, session, 'bob');

    await UniqueData.db.updateRow(
      session,
      data.copyWith(email: 'jim'),
    );
    expect(await success, isFalse);
    var dataAfter = await UniqueData.db.findById(session, data.id!);
    expect(dataAfter?.email, 'jim');
  });
}
