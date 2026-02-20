import 'dart:io';

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
    await UniqueDataWithNonPersist.db.deleteWhere(
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

  group('Given an empty database and a table model with non persistent fields',
      () {
    test(
      'when inserting more than 100 rows with ignoreConflicts then a performance warning is logged.',
      () async {
        var data = List.generate(
          101,
          (i) => UniqueDataWithNonPersist(
            number: i,
            email: '$i@serverpod.dev',
            extra: 'extra-$i',
          ),
        );

        var output = StringBuffer();
        await IOOverrides.runZoned(
          () async {
            await UniqueDataWithNonPersist.db.insert(
              session,
              data,
              ignoreConflicts: true,
            );
          },
          stderr: () => _StderrCapture(output),
        );

        expect(
          output.toString(),
          contains(
            'WARNING: Inserting 101 rows with ignoreConflicts on a model '
            'with non-persistent fields.',
          ),
        );
      },
    );

    test(
      'when inserting with ignoreConflicts then all rows are inserted with non-persistent fields preserved.',
      () async {
        var data = <UniqueDataWithNonPersist>[
          UniqueDataWithNonPersist(
            number: 1,
            email: 'a@serverpod.dev',
            extra: 'extra-a',
          ),
          UniqueDataWithNonPersist(
            number: 2,
            email: 'b@serverpod.dev',
            extra: 'extra-b',
          ),
        ];

        var inserted = await UniqueDataWithNonPersist.db.insert(
          session,
          data,
          ignoreConflicts: true,
        );

        expect(inserted, hasLength(2));
        expect(inserted[0].extra, 'extra-a');
        expect(inserted[1].extra, 'extra-b');

        var allRows = await UniqueDataWithNonPersist.db.find(session);
        expect(allRows, hasLength(2));
      },
    );
  });

  group(
      'Given a row with a unique constraint and a table model with non persistent fields',
      () {
    setUp(() async {
      await UniqueDataWithNonPersist.db.insertRow(
        session,
        UniqueDataWithNonPersist(
          number: 1,
          email: 'existing@serverpod.dev',
        ),
      );
    });

    test(
      'when inserting a conflicting row with ignoreConflicts then an empty list is returned.',
      () async {
        var inserted = await UniqueDataWithNonPersist.db.insert(
          session,
          [
            UniqueDataWithNonPersist(
              number: 2,
              email: 'existing@serverpod.dev',
              extra: 'should-be-skipped',
            ),
          ],
          ignoreConflicts: true,
        );

        expect(inserted, isEmpty);
      },
    );

    test(
      'when inserting a mix of new and conflicting rows with ignoreConflicts then only new rows are returned with non-persistent fields preserved.',
      () async {
        var data = <UniqueDataWithNonPersist>[
          UniqueDataWithNonPersist(
            number: 2,
            email: 'existing@serverpod.dev',
            extra: 'conflict-extra',
          ),
          UniqueDataWithNonPersist(
            number: 3,
            email: 'new@serverpod.dev',
            extra: 'new-extra',
          ),
        ];

        var inserted = await UniqueDataWithNonPersist.db.insert(
          session,
          data,
          ignoreConflicts: true,
        );

        expect(inserted, hasLength(1));
        expect(inserted.first.email, 'new@serverpod.dev');
        expect(inserted.first.extra, 'new-extra');
        expect(inserted.first.id, isNotNull);

        var allRows = await UniqueDataWithNonPersist.db.find(session);
        expect(allRows, hasLength(2));
      },
    );

    test(
      'when inserting with ignoreConflicts within a transaction then only non-conflicting rows are inserted with non-persistent fields preserved.',
      () async {
        await session.db.transaction((transaction) async {
          var data = <UniqueDataWithNonPersist>[
            UniqueDataWithNonPersist(
              number: 2,
              email: 'existing@serverpod.dev',
              extra: 'conflict-extra',
            ),
            UniqueDataWithNonPersist(
              number: 3,
              email: 'transacted@serverpod.dev',
              extra: 'transacted-extra',
            ),
          ];

          var inserted = await UniqueDataWithNonPersist.db.insert(
            session,
            data,
            transaction: transaction,
            ignoreConflicts: true,
          );

          expect(inserted, hasLength(1));
          expect(inserted.first.email, 'transacted@serverpod.dev');
          expect(inserted.first.extra, 'transacted-extra');
        });

        var allRows = await UniqueDataWithNonPersist.db.find(session);
        expect(allRows, hasLength(2));
      },
    );

    test(
      'when all rows conflict with ignoreConflicts then an empty list is returned.',
      () async {
        var inserted = await UniqueDataWithNonPersist.db.insert(
          session,
          [
            UniqueDataWithNonPersist(
              number: 2,
              email: 'existing@serverpod.dev',
              extra: 'extra-1',
            ),
          ],
          ignoreConflicts: true,
        );

        expect(inserted, isEmpty);

        var allRows = await UniqueDataWithNonPersist.db.find(session);
        expect(allRows, hasLength(1));
      },
    );
  });
}

class _StderrCapture implements Stdout {
  final StringBuffer _buffer;

  _StderrCapture(this._buffer);

  @override
  void writeln([Object? object = '']) => _buffer.writeln(object);

  @override
  void write(Object? object) => _buffer.write(object);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
