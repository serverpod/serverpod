import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await UniqueData.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  test(
      'Given a list of entries when batch updating only a single column then no other data is updated.',
      () async {
    var expectedFirstEmail = 'info@serverpod.dev';
    var expectedLastEmail = 'dev@serverpod.dev';
    var expectedFirstNumber = 5;
    var expectedLastNumber = 6;

    var data = <UniqueData>[
      UniqueData(number: 1, email: expectedFirstEmail),
      UniqueData(number: 2, email: expectedLastEmail),
    ];

    var inserted = await UniqueData.db.insert(session, data);

    var toUpdate = <UniqueData>[
      UniqueData(
        id: inserted.first.id,
        number: expectedFirstNumber,
        email: 'new@serverpod.dev',
      ),
      UniqueData(
        id: inserted.last.id,
        number: expectedLastNumber,
        email: 'email@serverpod.dev',
      ),
    ];

    var updated = await UniqueData.db.update(
      session,
      toUpdate,
      columns: (t) => [t.number],
    );

    expect(updated.first.number, expectedFirstNumber);
    expect(updated.last.number, expectedLastNumber);

    expect(updated.first.email, expectedFirstEmail);
    expect(updated.last.email, expectedLastEmail);
  });

  test(
      'Given a list of entries to update where one does not have an id then an error is thrown.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
    ];

    var inserted = await UniqueData.db.insert(session, data);

    var toUpdate = [
      ...inserted,
      UniqueData(number: 3, email: 'extra@serverpod.dev'),
    ];

    expect(
      UniqueData.db.update(
        session,
        toUpdate,
        columns: (_) => [SimpleData.t.num],
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
      'Given a list of entries trying to update a column that does not exist then an error is thrown.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
    ];

    var inserted = await UniqueData.db.insert(session, data);

    expect(
      UniqueData.db.update(
        session,
        inserted,
        columns: (_) => [SimpleData.t.num],
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
      'Given an model when updatingRow with a specific column only that column and no other data is updated.',
      () async {
    var expectedEmail = 'info@serverpod.dev';
    var expectedNumber = 5;

    var inserted = await UniqueData.db.insertRow(
      session,
      UniqueData(number: 1, email: expectedEmail),
    );

    var toUpdate = UniqueData(
      id: inserted.id,
      number: expectedNumber,
      email: 'new@serverpod.dev',
    );

    var updated = await UniqueData.db.updateRow(
      session,
      toUpdate,
      columns: (t) => [t.number],
    );

    expect(updated.number, expectedNumber);

    expect(updated.email, expectedEmail);
  });

  test('Given an model without an id when updatingRow then an error is thrown.',
      () async {
    expect(
      UniqueData.db.updateRow(
        session,
        UniqueData(number: 1, email: 'info@serverpod.dev'),
        columns: (t) => [t.number],
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
      'Given an model trying to updateRow with a column that does not exist then an error is thrown.',
      () async {
    var inserted = await UniqueData.db.insertRow(
      session,
      UniqueData(number: 1, email: 'info@serverpod.dev'),
    );

    expect(
      UniqueData.db.updateRow(
        session,
        inserted,
        columns: (_) => [SimpleData.t.num],
      ),
      throwsA(isA<ArgumentError>()),
    );
  });
}
