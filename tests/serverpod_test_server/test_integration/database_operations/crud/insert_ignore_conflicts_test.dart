import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await UniqueData.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
  });

  group('Given an empty database', () {
    test(
      'when inserting with ignoreConflicts then all rows are inserted and returned.',
      () async {
        var data = <UniqueData>[
          UniqueData(number: 1, email: 'a@serverpod.dev'),
          UniqueData(number: 2, email: 'b@serverpod.dev'),
        ];

        var inserted = await UniqueData.db.insert(
          session,
          data,
          ignoreConflicts: true,
        );

        expect(inserted, hasLength(2));

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(2));
      },
    );
  });

  group('Given a row with a unique constraint', () {
    setUp(() async {
      await UniqueData.db.insertRow(
        session,
        UniqueData(number: 1, email: 'existing@serverpod.dev'),
      );
    });

    test(
      'when inserting a conflicting row with ignoreConflicts then an empty list is returned.',
      () async {
        var inserted = await UniqueData.db.insert(
          session,
          [UniqueData(number: 2, email: 'existing@serverpod.dev')],
          ignoreConflicts: true,
        );

        expect(inserted, isEmpty);
      },
    );

    test(
      'when inserting a mix of new and conflicting rows with ignoreConflicts then only new rows are returned.',
      () async {
        var data = <UniqueData>[
          UniqueData(number: 2, email: 'existing@serverpod.dev'),
          UniqueData(number: 3, email: 'new@serverpod.dev'),
        ];

        var inserted = await UniqueData.db.insert(
          session,
          data,
          ignoreConflicts: true,
        );

        expect(inserted, hasLength(1));
        expect(inserted.first.email, 'new@serverpod.dev');
        expect(inserted.first.id, isNotNull);

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(2));
      },
    );

    test(
      'when inserting a conflicting row without ignoreConflicts then a DatabaseQueryException is thrown.',
      () async {
        expect(
          UniqueData.db.insert(
            session,
            [UniqueData(number: 2, email: 'existing@serverpod.dev')],
          ),
          throwsA(
            isA<DatabaseQueryException>().having(
              (e) => e.code,
              'code',
              PgErrorCode.uniqueViolation,
            ),
          ),
        );
      },
    );

    test(
      'when inserting with ignoreConflicts within a transaction then only non-conflicting rows are inserted.',
      () async {
        await session.db.transaction((transaction) async {
          var data = <UniqueData>[
            UniqueData(number: 2, email: 'existing@serverpod.dev'),
            UniqueData(number: 3, email: 'transacted@serverpod.dev'),
          ];

          var inserted = await UniqueData.db.insert(
            session,
            data,
            transaction: transaction,
            ignoreConflicts: true,
          );

          expect(inserted, hasLength(1));
          expect(inserted.first.email, 'transacted@serverpod.dev');
        });

        var allRows = await UniqueData.db.find(session);
        expect(allRows, hasLength(2));
      },
    );
  });
}
