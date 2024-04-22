import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group(
      'Given a simple data object in database when fetching with unsafeQuery using parameter binding',
      () {
    late SimpleData entry_1;
    late SimpleData entry_2;
    late DatabaseResult all_rows;
    late DatabaseResult list_param;
    late DatabaseResult named_param;
    setUpAll(() async {
      entry_1 = await SimpleData.db.insertRow(session, SimpleData(num: 1));
      entry_2 = await SimpleData.db.insertRow(session, SimpleData(num: 2));
      all_rows = await session.db.unsafeQuery(
        r'SELECT * FROM simple_data WHERE id in ($1, $2);',
        parameters: [entry_1.id, entry_2.id],
      );
      list_param = await session.db.unsafeQuery(
        r'SELECT * FROM simple_data where id=$1;',
        parameters: [entry_1.id],
      );
      named_param = await session.db.unsafeQuery(
        r'SELECT * FROM simple_data where id=@id;',
        parameters: {'id': entry_2.id},
      );
    });

    tearDownAll(() async {
      await SimpleData.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
    });

    test('then schema contains column descriptions.', () async {
      var columnDescriptions = list_param.schema.columns.toList();
      expect(columnDescriptions.length, 2);
      expect(columnDescriptions.map((e) => e.columnName), ['id', 'num']);
    });

    test('then all_rows reports the correct number of rows.', () async {
      expect(all_rows.length, 2);
    });

    test('then list_result reports affected rows.', () async {
      expect(list_param.affectedRowCount, 1);
    });

    test('then list_result reports the correct record.', () async {
      expect(list_param.firstOrNull?.toColumnMap(), {'id': entry_1.id, 'num': 1});
    });

    test('then named_result reports affected rows.', () async {
      expect(named_param.affectedRowCount, 1);
    });

    test('then named_result reports the correct record.', () async {
      expect(named_param.firstOrNull?.toColumnMap(), {'id': entry_2.id, 'num': 2});
    });

  });

  group(
      'Given a simple data object in database when fetching with unsafeExecute using parameter binding',
          () {
        late SimpleData entry_1;
        late SimpleData entry_2;
        late int list_affected;
        late int named_affected;
        late DatabaseResult list_result;
        late DatabaseResult named_result;
        setUpAll(() async {
          entry_1 = await SimpleData.db.insertRow(session, SimpleData(num: 1));
          entry_2 = await SimpleData.db.insertRow(session, SimpleData(num: 2));
          list_affected = await session.db.unsafeExecute(
            r'UPDATE simple_data SET num=10 WHERE id=$1;',
            parameters: [entry_1.id],
          );
          named_affected = await session.db.unsafeExecute(
            r'UPDATE simple_data SET num=20 WHERE id=@id;',
            parameters: {'id': entry_2.id},
          );
          list_result = await session.db.unsafeQuery(
            r'SELECT * FROM simple_data where id=$1;',
            parameters: [entry_1.id],
          );
          named_result = await session.db.unsafeQuery(
            r'SELECT * FROM simple_data where id=@id;',
            parameters: {'id': entry_2.id},
          );
        });

        tearDownAll(() async {
          await SimpleData.db
              .deleteWhere(session, where: (t) => Constant.bool(true));
        });

        test('then list_affected reports affected rows.', () async {
          expect(list_affected, 1);
        });

        test('then named_affected reports affected rows.', () async {
          expect(named_affected, 1);
        });

        test('then list_result reports the correct record.', () async {
          expect(list_result.firstOrNull?.toColumnMap(), {'id': entry_1.id, 'num': 10});
        });

        test('then named_result reports the correct record.', () async {
          expect(named_result.firstOrNull?.toColumnMap(), {'id': entry_2.id, 'num': 20});
        });

      });
}
