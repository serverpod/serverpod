import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await SimpleData.db.deleteWhere(session, where: (_) => Constant.bool(true));
    await UniqueData.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  group('Given an empty database', () {
    test(
        'when trying to delete a row that doesn\'t exist then an error is thrown.',
        () {
      expect(
        SimpleData.db.deleteRow(
          session,
          SimpleData(id: 1, num: 1),
        ),
        throwsA(isA<DatabaseDeleteRowException>()),
      );
    });

    test(
        'when trying to batch delete a row that doesn\'t exist then an error is thrown.',
        () {
      expect(
        SimpleData.db.delete(
          session,
          [SimpleData(id: 1, num: 1)],
        ),
        throwsA(isA<DatabaseException>()),
      );
    },
        skip:
            'This call is not atomic but should be, reenable this test when bug is fixed.');

    test('when trying to delete where (all) then an empty list is returned.',
        () async {
      var result = await SimpleData.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );

      expect(result, []);
    });
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

  group(' ', () {
    tearDown(() async {
      await RelatedUniqueData.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      );
      await SimpleData.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      );
      await UniqueData.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      );
    });

    test(
        'Given an inserted object when deleting that row then the id of the row is returned.',
        () async {
      var simpleData = SimpleData(num: 1);
      var inserted = await SimpleData.db.insertRow(session, simpleData);

      var deleted = await await SimpleData.db.deleteRow(
        session,
        inserted,
      );
      expect(deleted.id!, inserted.id);
    });

    test(
        'Given an inserted object when deleting that row then it cannot be retrieved from the db.',
        () async {
      var simpleData = SimpleData(num: 1);
      var inserted = await SimpleData.db.insertRow(session, simpleData);
      var deleted = await SimpleData.db.deleteRow(session, inserted);

      var retrieved = await SimpleData.db.findById(session, deleted.id!);

      expect(retrieved, isNull);
    });

    test(
        'Given two inserted objects when deleting all then the ids of the rows are returned.',
        () async {
      var simpleData1 = SimpleData(num: 1);
      var simpleData2 = SimpleData(num: 2);
      var inserted1 = await SimpleData.db.insertRow(session, simpleData1);
      var inserted2 = await SimpleData.db.insertRow(session, simpleData2);

      var deleted = await SimpleData.db.deleteWhere(
        where: (t) => Constant.bool(true),
        session,
      );

      var deletedIds = deleted.map((e) => e.id);

      expect(deletedIds, hasLength(2));
      expect(deletedIds, contains(inserted1.id));
      expect(deletedIds, contains(inserted2.id));
    });

    test(
        'Given two entries in the database when batch deleting the rows then the deleted ids are returned.',
        () async {
      var data = <UniqueData>[
        UniqueData(number: 1, email: 'info@serverpod.dev'),
        UniqueData(number: 2, email: 'dev@serverpod.dev'),
      ];

      var inserted = await UniqueData.db.insert(session, data);

      var deletedIds = await UniqueData.db.delete(session, inserted);

      expect(deletedIds.first.id!, inserted.first.id);
      expect(deletedIds.last.id!, inserted.last.id);
    });

    test(
        'Given two entries in the database when batch deleting the rows then the rows are deleted from the database.',
        () async {
      var data = <UniqueData>[
        UniqueData(number: 1, email: 'info@serverpod.dev'),
        UniqueData(number: 2, email: 'dev@serverpod.dev'),
      ];

      var inserted = await UniqueData.db.insert(session, data);

      await UniqueData.db.delete(session, inserted);

      var first = await UniqueData.db.findById(session, inserted.first.id!);
      var last = await UniqueData.db.findById(session, inserted.last.id!);

      expect(first, isNull);
      expect(last, isNull);
    });

    test(
        'Given two entries in the database when batch deleting fails no rows are deleted from the database.',
        () async {
      var data = <UniqueData>[
        UniqueData(number: 1, email: 'info@serverpod.dev'),
        UniqueData(number: 2, email: 'dev@serverpod.dev'),
      ];

      var inserted = await UniqueData.db.insert(session, data);

      var relationalData = RelatedUniqueData(
        number: 1,
        uniqueDataId: inserted.last.id!,
      );

      // This restricts the delete of the second entry
      RelatedUniqueData.db.insertRow(session, relationalData);

      expect(
        UniqueData.db.delete(session, inserted),
        throwsA(isA<DatabaseException>()),
      );

      var first = await UniqueData.db.findById(session, inserted.first.id!);
      var last = await UniqueData.db.findById(session, inserted.last.id!);

      expect(first, isNotNull);
      expect(last, isNotNull);
    });

    test(
        'Given two entries in the database when batch deleting one the other entry is still in the database.',
        () async {
      var data = <UniqueData>[
        UniqueData(number: 1, email: 'info@serverpod.dev'),
        UniqueData(number: 2, email: 'dev@serverpod.dev'),
      ];

      var inserted = await UniqueData.db.insert(session, data);

      await UniqueData.db.delete(session, [inserted.first]);

      var first = await UniqueData.db.findById(session, inserted.first.id!);
      var last = await UniqueData.db.findById(session, inserted.last.id!);

      expect(first, isNull);
      expect(last, isNotNull);
    });

    test(
        'Given two entries in the database when batch deleting one only that id is returned.',
        () async {
      var data = <UniqueData>[
        UniqueData(number: 1, email: 'info@serverpod.dev'),
        UniqueData(number: 2, email: 'dev@serverpod.dev'),
      ];

      var inserted = await UniqueData.db.insert(session, data);

      var deleted = await UniqueData.db.delete(session, [inserted.first]);

      expect(deleted, hasLength(1));
      expect(deleted.first.id!, inserted.first.id);
    });
  });
}
