import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given an empty database', () {
    tearDown(() async {
      await RelatedUniqueData.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
      await Types.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await UniqueData.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });
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
      },
    );

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
          throwsA(
            isA<DatabaseQueryException>().having(
              (e) => e.code,
              'code',
              PgErrorCode.uniqueViolation,
            ),
          ),
        );

        var first = await UniqueData.db.findFirstRow(
          session,
          where: (t) => t.email.equals('info@serverpod.dev'),
        );
        expect(first, isNull);

        var second = await UniqueData.db.findFirstRow(
          session,
          where: (t) => t.email.equals('dev@serverpod.dev'),
        );
        expect(second, isNull);
      },
    );

    test(
      'when batch inserting with an id defined then the id is not ignored.',
      () async {
        const int id = 999;

        var data = <UniqueData>[
          UniqueData(id: id, number: 1, email: 'info@serverpod.dev'),
        ];

        var inserted = await UniqueData.db.insert(session, data);

        expect(inserted.first.id, id);
      },
    );

    test(
      'when batch inserting with an id defined and other undefined then both are created in the database.',
      () async {
        const int id = 1999;

        var data = <UniqueData>[
          UniqueData(id: id, number: 10, email: 'info@serverpod.dev'),
          UniqueData(number: 20, email: 'dev@serverpod.dev'),
        ];

        var inserted = await UniqueData.db.insert(session, data);

        expect(inserted, hasLength(2));

        var first = inserted
            .where((e) => e.email == 'info@serverpod.dev')
            .single;
        var second = inserted
            .where((e) => e.email == 'dev@serverpod.dev')
            .single;

        expect(first.id, id);
        expect(second.id, isNot(id));
        expect(first.number, 10);
        expect(second.number, 20);
      },
    );
  });

  group('Given an object data without an id when calling insertRow', () {
    late SimpleData inserted;
    setUp(() async {
      var simpleData = SimpleData(num: 1);
      inserted = await SimpleData.db.insertRow(
        session,
        simpleData,
      );
    });
    tearDown(() async {
      await SimpleData.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    test(' then the created object is returned.', () async {
      expect(inserted.id, isNotNull);
      expect(inserted.num, 1);
    });
  });

  group('Given a model without fields when inserting it', () {
    late EmptyModelWithTable inserted;
    setUp(() async {
      var emptyModel = EmptyModelWithTable();
      inserted = await EmptyModelWithTable.db.insertRow(
        session,
        emptyModel,
      );
    });

    tearDown(() async {
      await EmptyModelWithTable.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    test('then the model is created.', () async {
      expect(inserted.id, isNotNull);
    });
  });

  group('Given a model with required field', () {
    tearDown(() async {
      await ModelWithRequiredField.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    test('when inserting then it is created', () async {
      var model = ModelWithRequiredField(name: 'John', email: null);
      var inserted = await ModelWithRequiredField.db.insertRow(session, model);

      expect(inserted.id, isNotNull);
    });
  });
}
