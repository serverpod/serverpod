import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given two simple data objects in database', () {
    group('when querying using positional arguments', () {
      late SimpleData entry_1;
      late SimpleData entry_2;
      setUpAll(() async {
        entry_1 = await SimpleData.db.insertRow(session, SimpleData(num: 1));
        entry_2 = await SimpleData.db.insertRow(session, SimpleData(num: 2));
      });

      tearDownAll(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      test(
        'then querying for both records reports the correct number of rows.',
        () async {
          var result = await session.db.unsafeQuery(
            r'SELECT * FROM simple_data WHERE id IN ($1, $2);',
            parameters: QueryParameters.positional([entry_1.id, entry_2.id]),
          );
          expect(result.length, 2);
        },
      );

      test(
        'then querying for a single record reports the correct record.',
        () async {
          var result = await session.db.unsafeQuery(
            r'SELECT * FROM simple_data WHERE id=$1;',
            parameters: QueryParameters.positional([entry_1.id]),
          );
          expect(result.length, 1);
          expect(result.firstOrNull?.toColumnMap(), {
            'id': entry_1.id,
            'num': 1,
          });
        },
      );
    });

    group('when querying using named arguments', () {
      late SimpleData entry_1;
      late SimpleData entry_2;
      late DatabaseResult result;
      setUpAll(() async {
        entry_1 = await SimpleData.db.insertRow(session, SimpleData(num: 1));
        entry_2 = await SimpleData.db.insertRow(session, SimpleData(num: 2));
      });

      tearDownAll(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      test(
        'then querying for both records reports the correct number of rows.',
        () async {
          late DatabaseResult result;
          result = await session.db.unsafeQuery(
            r'SELECT * FROM simple_data WHERE id IN (@entry1, @entry2);',
            parameters: QueryParameters.named({
              'entry1': entry_1.id,
              'entry2': entry_2.id,
            }),
          );
          expect(result.length, 2);
        },
      );

      test(
        'then querying for a single record reports the correct record.',
        () async {
          result = await session.db.unsafeQuery(
            r'SELECT * FROM simple_data WHERE id=@id;',
            parameters: QueryParameters.named({'id': entry_2.id}),
          );
          expect(result.affectedRowCount, 1);
          expect(result.firstOrNull?.toColumnMap(), {
            'id': entry_2.id,
            'num': 2,
          });
        },
      );
    });

    group('when executing using positional arguments', () {
      late SimpleData entry_1;
      late SimpleData entry_2;
      setUpAll(() async {
        entry_1 = await SimpleData.db.insertRow(session, SimpleData(num: 1));
        entry_2 = await SimpleData.db.insertRow(session, SimpleData(num: 2));
      });

      tearDownAll(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      test(
        'then executing a query for both records reports the correct number of rows.',
        () async {
          var result = await session.db.unsafeExecute(
            r'SELECT * FROM simple_data WHERE id IN ($1, $2);',
            parameters: QueryParameters.positional([entry_1.id, entry_2.id]),
          );
          expect(result, 2);
        },
      );

      test(
        'then executing an update on a single record reports the correct number of rows.',
        () async {
          var result = await session.db.unsafeExecute(
            r'UPDATE simple_data SET num=10 WHERE id=$1;',
            parameters: QueryParameters.positional([entry_1.id]),
          );
          expect(result, 1);
        },
      );
    });

    group('when executing using named arguments', () {
      late SimpleData entry_1;
      late SimpleData entry_2;
      setUpAll(() async {
        entry_1 = await SimpleData.db.insertRow(session, SimpleData(num: 1));
        entry_2 = await SimpleData.db.insertRow(session, SimpleData(num: 2));
      });

      tearDownAll(() async {
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      test(
        'then executing a query for both records reports the correct number of rows.',
        () async {
          var result = await session.db.unsafeExecute(
            r'SELECT * FROM simple_data WHERE id IN (@entry_1, @entry_2);',
            parameters: QueryParameters.named({
              'entry_1': entry_1.id,
              'entry_2': entry_2.id,
            }),
          );
          expect(result, 2);
        },
      );

      test(
        'then executing an update on a single record reports the correct number of rows.',
        () async {
          var result = await session.db.unsafeExecute(
            r'UPDATE simple_data SET num=10 WHERE id=@entry_1;',
            parameters: QueryParameters.named({'entry_1': entry_1.id}),
          );
          expect(result, 1);
        },
      );
    });
  });
}
