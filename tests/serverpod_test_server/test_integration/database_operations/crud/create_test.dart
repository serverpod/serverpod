import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

Future<void> deleteAll(Session session) async {
  await RelatedUniqueData.db
      .deleteWhere(session, where: (t) => Constant.bool(true));
  await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
  await UniqueData.db.deleteWhere(session, where: (t) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given an empty database', () {
    tearDown(() async => await deleteAll(session));
    test(
        'when batch inserting then all the entries are created in the database.',
        () async {
      var data = <UniqueData>[
        UniqueData(number: 1, email: 'info@serverpod.dev'),
        UniqueData(number: 2, email: 'dev@serverpod.dev'),
      ];

      var inserted = await UniqueData.db.insert(session, data);

      expect(inserted, hasLength(2));

      var simpleList = await UniqueData.db.find(session);

      expect(inserted.first.id, equals(simpleList.first.id));
      expect(inserted.last.id, equals(simpleList.last.id));
    });

    test(
        'when batch inserting with one failing row then no entries are created in the database.',
        () async {
      var data = <UniqueData>[
        UniqueData(number: 2, email: 'info@serverpod.dev'),
        UniqueData(number: 2, email: 'dev@serverpod.dev'),
        UniqueData(number: 2, email: 'dev@serverpod.dev'),
      ];

      expect(
        UniqueData.db.insert(session, data),
        throwsA(isA<DatabaseException>()),
      );

      var first = await UniqueData.db.findFirstRow(session,
          where: (t) => t.email.equals('info@serverpod.dev'));
      expect(first, isNull);

      var second = await UniqueData.db.findFirstRow(session,
          where: (t) => t.email.equals('dev@serverpod.dev'));
      expect(second, isNull);
    });

    test('when batch inserting with an id defined then the id is ignored.',
        () async {
      const int max = 1 >>> 1;

      var data = <UniqueData>[
        UniqueData(id: max, number: 1, email: 'info@serverpod.dev'),
      ];

      var inserted = await UniqueData.db.insert(session, data);

      expect(inserted.first.id, isNot(max));
    });
  });

  test(
      'Given an object data without an id when calling insertRow then the created object is returned.',
      () async {
    var simpleData = SimpleData(num: 1);
    var inserted = await SimpleData.db.insertRow(
      session,
      simpleData,
    );

    expect(inserted.id, isNotNull);
    expect(inserted.num, 1);
  });
}
