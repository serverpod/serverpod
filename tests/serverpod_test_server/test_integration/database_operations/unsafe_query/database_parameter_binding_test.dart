import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group(
      'Given a simple data object in database when fetching with query using positional parameter binding',
      () {
    late SimpleData entry_1;
    late SimpleData entry_2;
    late DatabaseResult all_rows;
    late DatabaseResult list_param;
    setUpAll(() async {
      entry_1 = await SimpleData.db.insertRow(session, SimpleData(num: 1));
      entry_2 = await SimpleData.db.insertRow(session, SimpleData(num: 2));
      all_rows = await session.db.query(
        r'SELECT * FROM simple_data WHERE id IN ($1, $2);',
        parameters: QueryParameters.positional([entry_1.id, entry_2.id]),
      );
      list_param = await session.db.query(
        r'SELECT * FROM simple_data WHERE id=$1;',
        parameters: QueryParameters.positional([entry_1.id]),
      );
    });

    tearDownAll(() async {
      await SimpleData.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
    });

    test('then all_rows reports the correct number of rows.', () async {
      expect(all_rows.length, 2);
    });

    test('then positional_result reports affected rows.', () async {
      expect(list_param.affectedRowCount, 1);
    });

    test('then positional_result reports the correct record.', () async {
      expect(
          list_param.firstOrNull?.toColumnMap(), {'id': entry_1.id, 'num': 1});
    });
  });

  group(
      'Given a simple data object in database when fetching with query using named parameter binding',
      () {
    late SimpleData entry_1;
    late SimpleData entry_2;
    late DatabaseResult all_rows;
    late DatabaseResult named_param;
    setUpAll(() async {
      entry_1 = await SimpleData.db.insertRow(session, SimpleData(num: 1));
      entry_2 = await SimpleData.db.insertRow(session, SimpleData(num: 2));
      all_rows = await session.db.query(
        r'SELECT * FROM simple_data WHERE id IN (@entry1, @entry2);',
        parameters: QueryParameters.named({
          'entry1': entry_1.id,
          'entry2': entry_2.id,
        }),
      );
      named_param = await session.db.query(
        r'SELECT * FROM simple_data WHERE id=@id;',
        parameters: QueryParameters.named({'id': entry_2.id}),
      );
    });

    tearDownAll(() async {
      await SimpleData.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
    });

    test('then all_rows reports the correct number of rows.', () async {
      expect(all_rows.length, 2);
    });

    test('then named_result reports affected rows.', () async {
      expect(named_param.affectedRowCount, 1);
    });

    test('then named_result reports the correct record.', () async {
      expect(
          named_param.firstOrNull?.toColumnMap(), {'id': entry_2.id, 'num': 2});
    });
  });

  group(
      'Given a simple data object in database when calling execute using positional parameter binding',
      () {
    late SimpleData entry;
    late int positional_affected;
    late DatabaseResult positional_result;
    setUpAll(() async {
      entry = await SimpleData.db.insertRow(session, SimpleData(num: 1));
      positional_affected = await session.db.execute(
        r'UPDATE simple_data SET num=10 WHERE id=$1;',
        parameters: QueryParameters.positional([entry.id]),
      );
      positional_result = await session.db.query(
        r'SELECT * FROM simple_data WHERE id=$1;',
        parameters: QueryParameters.positional([entry.id]),
      );
    });

    tearDownAll(() async {
      await SimpleData.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
    });

    test('then positional_affected reports affected rows.', () async {
      expect(positional_affected, 1);
    });

    test(
        'then positional_result with positional parameters reports the correct record.',
        () async {
      expect(positional_result.firstOrNull?.toColumnMap(),
          {'id': entry.id, 'num': 10});
    });
  });

  group(
      'Given a simple data object in database when calling execute using named parameter binding',
      () {
    late SimpleData entry;
    late int named_affected;
    late DatabaseResult named_result;
    setUpAll(() async {
      entry = await SimpleData.db.insertRow(session, SimpleData(num: 1));
      named_affected = await session.db.execute(
        r'UPDATE simple_data SET num=20 WHERE id=@id;',
        parameters: QueryParameters.named({'id': entry.id}),
      );
      named_result = await session.db.query(
        r'SELECT * FROM simple_data WHERE id=@id;',
        parameters: QueryParameters.named({'id': entry.id}),
      );
    });

    tearDownAll(() async {
      await SimpleData.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
    });

    test('then named_affected with named parameters reports affected rows.',
        () async {
      expect(named_affected, 1);
    });

    test('then named_result with named parameters reports the correct record.',
        () async {
      expect(
          named_result.firstOrNull?.toColumnMap(), {'id': entry.id, 'num': 20});
    });
  });
}
