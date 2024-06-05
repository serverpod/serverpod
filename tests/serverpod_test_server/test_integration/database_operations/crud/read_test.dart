import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await UniqueData.db.deleteWhere(session, where: (_) => Constant.bool(true));
    await SimpleData.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  test(
      'Given a list of entries when finding the first row by ordering and offsetting the query then the correct row is returned.',
      () async {
    var data = <UniqueData>[
      UniqueData(number: 1, email: 'info@serverpod.dev'),
      UniqueData(number: 2, email: 'dev@serverpod.dev'),
      UniqueData(number: 3, email: 'career@serverpod.dev'),
    ];

    await UniqueData.db.insert(session, data);

    var dev = await UniqueData.db.findFirstRow(
      session,
      orderBy: (t) => t.number,
      orderDescending: true,
      offset: 1,
    );

    expect(dev?.email, 'dev@serverpod.dev');
  });

  group('Given an empty database', () {
    test('when trying to find an object by id then null is returned.',
        () async {
      var retrieved = await SimpleData.db.findById(
        session,
        1,
      );

      expect(retrieved, isNull);
    });

    test('when trying to find a row then null is returned.', () async {
      var retrieved = await SimpleData.db.findFirstRow(
        session,
        where: (t) => t.num.equals(1),
      );

      expect(retrieved, isNull);
    });

    test('when trying to find all then an empty list is returned.', () async {
      var retrieved = await SimpleData.db.find(
        session,
        orderBy: (t) => t.id,
        limit: 10,
        offset: 0,
      );

      expect(retrieved, []);
    });
  });

  test(
      'Given an object that is inserted when retrieving it by id then the same object is returned.',
      () async {
    var simpleData = SimpleData(num: 1);
    var inserted = await SimpleData.db.insertRow(
      session,
      simpleData,
    );

    var retrieved = await SimpleData.db.findById(
      session,
      inserted.id!,
    );

    expect(retrieved, isNotNull);
    expect(inserted.id, retrieved!.id);
    expect(inserted.num, retrieved.num);
  });

  test(
      'Given two inserted objects when finding by row then the filtered row is returned',
      () async {
    var simpleData1 = SimpleData(num: 1);
    var simpleData2 = SimpleData(num: 2);
    await SimpleData.db.insertRow(session, simpleData1);
    var expected = await SimpleData.db.insertRow(session, simpleData2);

    var retrieved = await SimpleData.db.findFirstRow(
      session,
      where: (t) => t.num.equals(2),
    );

    expect(retrieved, isNotNull);
    expect(retrieved?.id, expected.id);
  });

  test(
      'Given two inserted objects when retrieving all then a list with the two objects is returned.',
      () async {
    var simpleData1 = SimpleData(num: 1);
    var simpleData2 = SimpleData(num: 2);
    var inserted1 = await SimpleData.db.insertRow(session, simpleData1);
    var inserted2 = await SimpleData.db.insertRow(session, simpleData2);

    var retrieved = await SimpleData.db.find(
      session,
      orderBy: (t) => t.id,
      limit: 10,
      offset: 0,
    );

    expect(retrieved, hasLength(2));
    expect(retrieved.first.id, inserted1.id);
    expect(retrieved.last.id, inserted2.id);
  });
}
