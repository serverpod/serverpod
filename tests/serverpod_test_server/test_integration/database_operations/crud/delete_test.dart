import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await SimpleData.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  group('Given a list of entries', () {
    late List<SimpleData> data;

    setUp(() async {
      data = await SimpleData.db.insert(session, [
        SimpleData(num: 1),
        SimpleData(num: 2),
        SimpleData(num: 3),
      ]);
    });

    group('when deleting row', () {
      late SimpleData deleteResult;
      setUp(() async {
        deleteResult = await SimpleData.db.deleteRow(session, data[0]);
      });

      test('then the row is removed', () async {
        var result = await SimpleData.db.find(session);

        expect(result, hasLength(2));
        var numbers = result.map((e) => e.num).toList();
        expect(numbers, [data[1].num, data[2].num]);
      });

      test('then removed row is returned', () async {
        expect(deleteResult.num, data[0].num);
      });
    });

    group('when deleting multiple rows', () {
      late List<SimpleData> deleteResult;

      setUp(() async {
        deleteResult = await SimpleData.db.delete(session, data.sublist(1));
      });

      test('then the rows are removed', () async {
        var result = await SimpleData.db.find(session);

        expect(result, hasLength(1));
        expect(result.firstOrNull?.num, data[0].num);
      });

      test('then removed rows are returned', () async {
        expect(deleteResult, hasLength(2));
        var numbers = deleteResult.map((e) => e.num).toList();
        expect(numbers, [data[1].num, data[2].num]);
      });
    });

    group('when deleting based on filter', () {
      late List<SimpleData> deleteResult;

      setUp(() async {
        deleteResult = await SimpleData.db.deleteWhere(
          session,
          where: (t) => t.num.inSet({data[0].num, data[2].num}),
        );
      });

      test('then the rows are removed', () async {
        var result = await SimpleData.db.find(session);

        expect(result, hasLength(1));
        expect(result.firstOrNull?.num, data[1].num);
      });

      test('then removed rows are returned', () async {
        expect(deleteResult, hasLength(2));
        var numbers = deleteResult.map((e) => e.num).toList();
        expect(numbers, [data[0].num, data[2].num]);
      });
    });
  });
}
